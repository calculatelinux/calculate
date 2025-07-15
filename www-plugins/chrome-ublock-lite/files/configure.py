#!/usr/bin/python3

import plyvel
import json
import sys
from os import path

data = json.load(sys.stdin)

if len(sys.argv) < 3:
    sys.stderr.write("configure.py chrome-dir ext-id")
    sys.exit(1)

chrome_dir = sys.argv[1]
ext_id = sys.argv[2]

db_path = path.join(chrome_dir,"Default/Local Extension Settings", ext_id)
db = plyvel.DB(db_path, create_if_missing=True)
for k,v in data.items():
    db.put(bytes(str(k), encoding='utf-8'), bytes(json.dumps(v), encoding='utf-8'))
db.close()

