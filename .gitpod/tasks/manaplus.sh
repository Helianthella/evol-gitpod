#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)
manaplus -C $GITPOD_REPO_ROOT/.manaplus
rm -f core.manaplus*
