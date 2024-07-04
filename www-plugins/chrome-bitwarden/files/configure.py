#!/usr/bin/env python

import requests
import base64
import hashlib
import secrets
import plyvel
import json
import sys
from os import path



def hash_key(password, salt=None, iterations=600000):
    """
    Хэширование ключа для хэширования пароля
    """

    if salt is None:
        salt = secrets.token_hex(16)
    assert salt and isinstance(salt, str) and "$" not in salt
    assert isinstance(password, str)
    pw_hash = hashlib.pbkdf2_hmac(
        "sha256", password.encode("utf-8"), salt.encode("utf-8"), iterations
    )
    key_hash = base64.b64encode(pw_hash).decode("ascii").strip()
    return key_hash


def hash_password(password, salt=None, iterations=600000):
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
    return password_hash


def authorization(password,login):
    """
    Авторизация и получение данных
    """

    global url, Key, PrivateKey, hashKey, access_token, refresh_token, userId

    pre_login_url = url + "/identity/accounts/prelogin"
    login_url = url + "/identity/connect/token"
    profile_url = url + "/api/accounts/profile"

    hashKey = hash_key(password,login)
    hashPassword = hash_password(hashKey, password, iterations=1)

    pre_login_data = {"email": login}
    login_data = {
        "scope": "api offline_access",
        "client_id": "web",
        "deviceType": "9",
        "deviceIdentifier": "ff75e99b-a577-4143-a553-f4083f1d2413",
        "deviceName": "chrome",
        "grant_type": "password",
        "username": login,
        "password": hashPassword
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
                        Key = auth_json['Key']
                        PrivateKey = auth_json['PrivateKey']
                        access_token = auth_json['access_token']
                        refresh_token = auth_json['refresh_token']
                        headers = {
                            "Authorization": f'Bearer {access_token}'
                        }
                        profile = session.get(profile_url, headers=headers)
                        profile_json = json.loads(profile.content)
                        userId = profile_json['Id']
                    except:
                        sys.stderr.write(auth.content.decode())
                        sys.exit(1)
            except:
                sys.stderr.write(pre_login.content.decode())
                sys.exit(1)
    except:
        sys.stderr.write(ping.content.decode())
        sys.exit(1)


def update_json(data_list):
    """
    Заполнение конфигурационного файла json
    """

    userId_masterkey_auto = f'{userId + "_masterkey_auto"}'
    data_list[f'{userId_masterkey_auto}'] = data_list.pop('userId_masterkey_auto')
    data_list[f'{userId}'] = data_list.pop('userId')
    id = data_list[f'{userId}']
    keys = id['keys']
    profile = id['profile']
    settings = id['settings']
    environmentUrls = settings['environmentUrls']
    tokens = id['tokens']
    keys['cryptoSymmetricKey']['encrypted'] = Key
    keys['privateKey']['encrypted'] = PrivateKey
    profile['userId'] = userId
    environmentUrls['base'] = url
    tokens['accessToken'] = access_token
    tokens['refreshToken'] = refresh_token
    data_list[f'{userId_masterkey_auto}'] = hashKey
    data_list['activeUserId'] = userId
    data_list['authenticatedAccounts'] = [userId]

    data_list[f'{userId}'] = json.dumps(id)
    data_list[f'{userId_masterkey_auto}'] = json.dumps(data_list[f'{userId_masterkey_auto}'])
    data_list['activeUserId'] = json.dumps(data_list['activeUserId'])
    data_list['authenticatedAccounts'] = json.dumps(data_list['authenticatedAccounts'])
    data_list['global'] = json.dumps(data_list['global'])


data_list = json.load(sys.stdin)

if len(sys.argv) < 5:
    sys.stderr.write("configure.py chrome-dir ext-id login password url")
    sys.exit(1)

chrome_dir = sys.argv[1]
ext_id = sys.argv[2]
login = sys.argv[3]
password = sys.argv[4]
url = sys.argv[5]

authorization(password,login)
update_json(data_list)

db_path = path.join(chrome_dir,"Default/Local Extension Settings", ext_id)
try:
    db = plyvel.DB(db_path, create_if_missing=True)
except IOError:
    sys.stderr.write("Закройте браузер!")
    sys.exit(1)

for k, v in data_list.items():
    db.put(bytes(k,encoding='utf-8'), bytes(str(v),encoding='utf-8'))
db.close()
