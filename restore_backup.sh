#!/bin/bash

CLIENTE=$1
FILIAL=$2

## PT - Isso foi criado pois alguns clientes especifico tem mais de um servidor(filial)
## EN - This was created because some specific clients have more than one server (branch)
LISTCLIENT='CLIENTE X'
LISTFILIAL=('FILIAL X' \
'FILIAL Y' \
'FILIAL Z')
######################

if [ "${CLIENTE}" == "${LISTCLIENT}" ]
then
    for i in "${LISTFILIAL[@]}"
    do
        if [ "${i}" == "${FILIAL}" ]
        then
            BKPFILE=$(/usr/bin/rclone lsl GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1 | /usr/bin/cut -d" " -f5)
            /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS /var/www/backup/
            /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILE"
            exit 0
        fi
    done
else
    BKPFILE=$(/usr/bin/rclone lsl GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1 | /usr/bin/cut -d" " -f5)
    /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS /var/www/backup/
    /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILE"
    echo "$BKPFILE"
    exit 0
fi
