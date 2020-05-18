#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)
manaplus
rm -f core.manaplus*