#!/bin/bash

pushd /workspace/evol-gitpod/.evol/server-data/sql-files 1>/dev/null
mysql --force <./initremote.sql &>/dev/null
mysql --force -u evol -pevol evol <<< $(sed "s/ENGINE=MyISAM;/ENGINE=InnoDB;/" main.sql) &>/dev/null
mysql --force -u evol -pevol evol <<< $(sed "s/ENGINE=MyISAM;/ENGINE=InnoDB;/" logs.sql) &>/dev/null
popd 1>/dev/null
