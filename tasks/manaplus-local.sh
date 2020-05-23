#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)

export MANAPLUS="/workspace/evol-gitpod/.evol/manaplus/src/manaplus"
if [ -f "$MANAPLUS" ]; then
    echo "Starting local manaplus"
else
    echo "Starting system manaplus"
    export MANAPLUS="manaplus"
fi


${MANAPLUS} -s 127.0.0.1 -p 6901 -y evol2 \
  -u -d /workspace/evol-gitpod/.evol/client-data /workspace/evol-gitpod/.evol/client-data/evol.manaplus
rm -f core.manaplus*
