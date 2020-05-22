#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)

export MANAPLUS="~/.evol/manaplus/src/manaplus"
if [ -f "$MANAPLUS" ]; then
    echo "Starting local manaplus"
else
    echo "Starting system manaplus"
    export MANAPLUS="manaplus"
fi


${MANAPLUS}
rm -f core.manaplus*
