#!/usr/bin/env python

import base64
import hashlib
import json
import secrets
import sys
import uuid
from dataclasses import dataclass
from os import path
from typing import Any
from time import time

import plyvel
import requests

try:
    from cryptography.hazmat.backends import default_backend
    from cryptography.hazmat.primitives import ciphers, hashes, hmac, kdf, padding
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    from cryptography.hazmat.primitives.kdf.hkdf import HKDF, HKDFExpand
    from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
except ModuleNotFoundError:
    print("This script depends on the 'cryptography' package")
    print("pip install cryptography")
    sys.exit(1)


BitwardenSecrets = {}


@dataclass
class Value:
    value: Any


class ExtendedEncoder(json.JSONEncoder):
    "Кодирование dict в формат json, который используется в leveldb"

    def default(self, o):
        if isinstance(o, Value):
            return {"__json__": True, "value": json.dumps(o.value)}
        else:
            return super().default(o)


def get_timestamp() -> int:
    "Вернуть timestamp в миллисекундах"
    return int(time() * 1000)


def getMasterKey(password, salt=None, iterations=600000):
    """
    Хэширование ключа для хэширования пароля
    """

    if salt is None:
        salt = secrets.token_hex(16)
    assert salt and isinstance(salt, str) and "$" not in salt
    assert isinstance(password, str)
    mk_bin = hashlib.pbkdf2_hmac(
        "sha256", password.encode("utf-8"), salt.encode("utf-8"), iterations
    )
    mk_b64 = base64.b64encode(mk_bin).decode("ascii").strip()
    BitwardenSecrets["MasterKey"] = mk_bin
    BitwardenSecrets["MasterKey_b64"] = mk_b64
    return mk_bin, mk_b64


def getMasterPasswordHash(password, salt=None, iterations=600000):
    """
    Хэширование пароля для авторизации
    """

    if salt is None:
        salt = secrets.token_hex(16)
    assert salt and isinstance(salt, str) and "$" not in salt
    pw_hash = hashlib.pbkdf2_hmac(
        "sha256", base64.b64decode(password), salt.encode("utf-8"), iterations
    )
    password_hash = base64.b64encode(pw_hash).decode("ascii").strip()
    BitwardenSecrets["MasterPasswordHash"] = password_hash
    return password_hash


def decryptProtectedSymmetricKey(CipherString, masterkey, mastermac):
    """
    Расшифровка главного ключа
    """

    encType = int(CipherString.split(".")[0])  # Not Currently Used, Assuming EncryptionType: 2
    if encType != 2:
        print(
            f"ERROR: Protected Symmetric Key was not decrypted. Unsupported EncryptionType: {encType}\n\n"
            "Rotating your account encryption key should resolve this for future backups of data.json.\n"
            "Unfortunately a new sync/backup will be required after rotaion. \n\n\n"
            "https://bitwarden.com/help/account-encryption-key/#rotate-your-encryption-key"
        )
        exit(1)

    iv = base64.b64decode(CipherString.split(".")[1].split("|")[0])
    ciphertext = base64.b64decode(CipherString.split(".")[1].split("|")[1])
    mac = base64.b64decode(CipherString.split(".")[1].split("|")[2])

    # Calculate CipherString MAC
    h = hmac.HMAC(mastermac, hashes.SHA256(), backend=default_backend())
    h.update(iv)
    h.update(ciphertext)
    calculatedMAC = h.finalize()

    if mac != calculatedMAC:
        print(
            "ERROR: MAC did not match. Protected Symmetric Key was not decrypted. (Password may be wrong)"
        )
        sys.exit(1)

    unpadder = padding.PKCS7(128).unpadder()
    cipher = Cipher(algorithms.AES(masterkey), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()
    decrypted = decryptor.update(ciphertext) + decryptor.finalize()

    try:
        cleartext = unpadder.update(decrypted) + unpadder.finalize()
    except Exception as e:
        print()
        print("Wrong Password. Could Not Decode Protected Symmetric Key.")
        sys.exit(1)

    stretchedmasterkey = cleartext
    enc = stretchedmasterkey[0:32]
    mac = stretchedmasterkey[32:64]

    return [stretchedmasterkey, enc, mac]


def getAutoAnlockKey(MasterKey, encKey):
    """
    Получение ключа для авторазблокировки
    """

    BitwardenSecrets["ProtectedSymmetricKey"] = encKey

    hkdf = HKDFExpand(algorithm=hashes.SHA256(), length=32, info=b"enc", backend=default_backend())

    BitwardenSecrets["StretchedEncryptionKey"] = hkdf.derive(MasterKey)

    hkdf = HKDFExpand(algorithm=hashes.SHA256(), length=32, info=b"mac", backend=default_backend())

    BitwardenSecrets["StretchedMACKey"] = hkdf.derive(MasterKey)
    BitwardenSecrets["StretchedMasterKey"] = (
        BitwardenSecrets["StretchedEncryptionKey"] + BitwardenSecrets["StretchedMACKey"]
    )
    (
        BitwardenSecrets["GeneratedSymmetricKey"],
        BitwardenSecrets["GeneratedEncryptionKey"],
        BitwardenSecrets["GeneratedMACKey"],
    ) = decryptProtectedSymmetricKey(
        BitwardenSecrets["ProtectedSymmetricKey"],
        BitwardenSecrets["StretchedEncryptionKey"],
        BitwardenSecrets["StretchedMACKey"],
    )
    BitwardenSecrets["GeneratedSymmetricKey_b64"] = base64.b64encode(
        BitwardenSecrets["GeneratedSymmetricKey"]
    ).decode("utf-8")

    return BitwardenSecrets["GeneratedSymmetricKey_b64"]


def authorization(password, login):
    """
    Авторизация и получение данных
    """

    global url

    pre_login_url = url + "/identity/accounts/prelogin"
    login_url = url + "/identity/connect/token"
    profile_url = url + "/api/accounts/profile"

    MasterKey, MasterKey_b64 = getMasterKey(password, login)
    MasterPasswordHash = getMasterPasswordHash(MasterKey_b64, password, iterations=1)

    pre_login_data = {"email": login}
    login_data = {
        "scope": "api offline_access",
        "client_id": "web",
        "deviceType": "9",
        "deviceIdentifier": "ff75e99b-a577-4143-a553-f4083f1d2413",
        "deviceName": "chrome",
        "grant_type": "password",
        "username": login,
        "password": MasterPasswordHash,
    }

    session = requests.Session()
    try:
        ping = session.get(url)
        if ping.status_code == 200:
            try:
                pre_login = session.post(pre_login_url, json=pre_login_data)
                if pre_login.status_code == 200:
                    try:
                        auth = session.post(login_url, data=login_data)
                        auth_json = json.loads(auth.content.decode())
                        headers = {"Authorization": f'Bearer {auth_json["access_token"]}'}
                        profile = session.get(profile_url, headers=headers)
                        profile_json = json.loads(profile.content)
                        BitwardenSecrets["Name"] = profile_json["name"]
                        Organizations = profile_json["organizations"][0]

                        BitwardenSecrets["MasterPasswordHashMobile"] = getMasterPasswordHash(
                            MasterKey_b64, password, iterations=2
                        )
                        BitwardenSecrets["ProtectedSymmetricKey"] = auth_json["Key"]
                        BitwardenSecrets["ProtectedRSAPrivateKey"] = auth_json["PrivateKey"]
                        BitwardenSecrets["AccessToken"] = auth_json["access_token"]
                        BitwardenSecrets["RefreshToken"] = auth_json["refresh_token"]
                        BitwardenSecrets["GeneratedSymmetricKey_b64"] = getAutoAnlockKey(
                            BitwardenSecrets["MasterKey"],
                            BitwardenSecrets["ProtectedSymmetricKey"],
                        )
                        BitwardenSecrets["UserId"] = profile_json["id"]
                        BitwardenSecrets["OrganizationId"] = Organizations["id"]
                        BitwardenSecrets["OrganizationKey"] = Organizations["key"]
                    except Exception as e:
                        sys.stderr.write(e)
                        sys.stderr.write(auth.content.decode())
                        sys.exit(1)
            except Exception as e:
                sys.stderr.write(e)
                sys.stderr.write(pre_login.content.decode())
                sys.exit(1)
    except Exception as e:
        sys.stderr.write(e)
        sys.stderr.write(ping.content.decode())
        sys.exit(1)


def update_json(data_list):
    """
    Заполнение конфигурационного файла json
    """

    userId = BitwardenSecrets["UserId"]

    # Замена Key
    for key, value in data_list.copy().items():
        if "userId" in key:
            new_key = key.replace("userId", BitwardenSecrets["UserId"])
            data_list[new_key] = data_list.pop(f"{key}")

    # Замена Value
    data_list[userId] = Value(
        {
            "keys": {"cryptoSymmetricKey": {}},
            "profile": {
                "userId": userId,
                "name": BitwardenSecrets["Name"],
                "email": login,
            },
        }
    )
    data_list["global_account_accounts"] = Value(
        {userId: {"name": BitwardenSecrets["Name"], "email": login, "emailVerified": True}}
    )
    data_list["global_account_activeAccountId"] = Value(userId)
    data_list[f"{userId}_user_auto"] = Value(BitwardenSecrets["GeneratedSymmetricKey_b64"])
    data_list[f"user_{userId}_token_accessToken"] = Value(BitwardenSecrets["AccessToken"])
    data_list[f"user_{userId}_token_refreshToken"] = Value(BitwardenSecrets["RefreshToken"])
    data_list[f"user_{userId}_environment_environment"] = Value(
        {"region": "Self-hosted", "urls": {"base": url}}
    )
    data_list[f"user_{userId}_crypto_privateKey"] = Value(
        BitwardenSecrets["ProtectedRSAPrivateKey"]
    )
    data_list[f"user_{userId}_crypto_organizationKeys"] = Value(
        {
            f"{BitwardenSecrets['OrganizationId']}": {
                "type": "organization",
                "key": BitwardenSecrets["OrganizationKey"],
            }
        }
    )
    data_list[f"user_{userId}_autofillSettings_autofillOnPageLoad"] = Value(True)
    data_list[f"user_{userId}_autofillSettings_autofillOnPageLoadDefault"] = Value(True)
    data_list[f"user_{userId}_userDecryptionOptions_decryptionOptions"] = Value(
        {"hasMasterPassword": True}
    )
    data_list[f"user_{userId}_domainSettings_defaultUriMatchStrategy"] = Value(1)
    data_list[f"user_{userId}_vaultTimeoutSettings_vaultTimeout"] = Value("never")

    data_list["global_taskScheduler_activeAlarms"] = Value(
        [
            {
                "alarmName": "vaultTimeoutCheckInterval__3",
                "startTime": get_timestamp(),
                "createInfo": {"periodInMinutes": 0.6666666666666666, "delayInMinutes": 1},
            },
            {
                "alarmName": "scheduleNextSyncInterval",
                "startTime": get_timestamp(),
                "createInfo": {"periodInMinutes": 5, "delayInMinutes": 5},
            },
        ]
    )


def show_database_json(db: plyvel.DB) -> None:
    "Dump базы данных расширения в формате json"

    def as_json(obj):
        if "__json__" in obj:
            if obj["__json__"]:
                return json.loads(obj["value"])

    print(
        json.dumps(
            {k.decode("utf-8"): json.loads(v, object_hook=as_json) for k, v in db}, indent=4
        )
    )


if __name__ == "__main__":
    data_list = json.load(sys.stdin)

    if len(sys.argv) < 5:
        sys.stderr.write("configure.py chrome-dir ext-id login password url")
        sys.exit(1)

    chrome_dir = sys.argv[1]
    ext_id = sys.argv[2]
    login = sys.argv[3]
    password = sys.argv[4]
    url = sys.argv[5]

    authorization(password, login)
    update_json(data_list)

    data_list = json.dumps(data_list, cls=ExtendedEncoder)

    try:
        with plyvel.DB(
            path.join(chrome_dir, "Default/Local Extension Settings", ext_id),
            create_if_missing=True,
        ) as db:
            for k, v in json.loads(data_list).items():
                db.put(k.encode("utf-8"), json.dumps(v).encode("utf-8"))

            # show_database_json(db)

    except IOError as e:
        print(f"""
              Закройте браузер!
              Сообщение ошибки: {e}
              """)
