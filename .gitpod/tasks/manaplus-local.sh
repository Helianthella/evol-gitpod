#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)
manaplus -C $GITPOD_REPO_ROOT/.manaplus -s 127.0.0.1 -p 6901 -y evol2 \
  -u -d $GITPOD_REPO_ROOT/client-data $GITPOD_REPO_ROOT/evol.manaplus
rm -f core.manaplus*
