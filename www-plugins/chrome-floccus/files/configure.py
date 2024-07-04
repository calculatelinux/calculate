#!/usr/bin/env python

import plyvel
import json
import sys
import time
import random
from os import path

def generate_accountId():
    """
    Генерация accountId
    """
    milliseconds = int(round(time.time() * 10000))
    randomnum = random.randint(10**16, 10**17 - 1)
    id = '{0}.{1}'.format(milliseconds, randomnum)
    return id


def update_json(data_list):
    """
    Заполнение конфигурационного файла json
    """

    accounts = data_list['accounts']
    accounts[f'{generate_accountId()}'] = accounts.pop('accountId')
    data_list['accounts'] = json.dumps(accounts)


if len(sys.argv) < 2:
    sys.stderr.write("configure.py chrome-dir ext-id")
    sys.exit(1)

chrome_dir = sys.argv[1]
ext_id = sys.argv[2]

data_list = json.load(sys.stdin)
update_json(data_list)

db_path = path.join(chrome_dir,"Default/Local Extension Settings", ext_id)
try:
    db = plyvel.DB(db_path, create_if_missing=True)
except IOError:
    sys.stderr.write("Закройте браузер!\n")
    sys.exit(1)

for k, v in data_list.items():
    db.put(bytes(k,encoding='utf-8'), bytes(str(v),encoding='utf-8'))
db.close()
