#!/bin/bash

mysql --force -u evol -pevol evol <<EOF
TRUNCATE TABLE `login`;
INSERT INTO `login` SET `userid`='adm1',`user_pass`='adm1',`group_id`=99;
INSERT INTO `login` SET `userid`='adm2',`user_pass`='adm2',`group_id`=99;
INSERT INTO `login` SET `userid`='adm',`user_pass`='adm',`group_id`=99;
INSERT INTO `login` SET `userid`='admin',`user_pass`='admin',`group_id`=99;
INSERT INTO `login` SET `userid`='usr1',`user_pass`='usr1';
INSERT INTO `login` SET `userid`='usr2',`user_pass`='usr2';
INSERT INTO `login` SET `userid`='user',`user_pass`='user';
EOF