#!/bin/bash

pushd ~/.evol/server-data/sql-files 1>/dev/null
mysql --force <./initremote.sql &>/dev/null
mysql --force -u evol -pevol evol <./main.sql &>/dev/null
mysql --force -u evol -pevol evol <./logs.sql &>/dev/null
popd 1>/dev/null
