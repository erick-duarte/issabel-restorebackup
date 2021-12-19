#!/bin/bash

# PT # O script aqui está bem basico, mas na verdade ele é mais complexo, pois existe algumas particularidades
# da empresa para qual fiz isso. Caso tiver interesse só entrar em contato.

# EN # The script here is very basic, but actually it is more complex, as there are some peculiarities
# of the company I did it for. If you are interested, just get in touch.

CLIENTE=$1
FILIAL=$2
DIRBASE="/var/www/backup/"

## PT - Isso foi criado pois alguns clientes especificoq que tem mais de um servidor(filial)
## EN - This was created because some customers specify that it has more than one server (branch)
LISTCLIENT='CLIENTE X'
LISTFILIAL=('FILIAL X' \
'FILIAL Y' \
'FILIAL Z')

if [ "${CLIENTE}" == "${LISTCLIENT}" ]
then
    for i in "${LISTFILIAL[@]}"
    do
        if [ "${i}" == "${FILIAL}" ]
        then
            BKPFILETAR=$(/usr/bin/rclone lsf --include "*.tar" GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1)
            FILES=( $BKPFILETAR ) # Isso nem precisava, mas só queria deixar a coisas mais interessantes
            for i in "${FILES[@]}"
            do
                /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS "$DIRBASE"
            done
            /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILETAR"
            /usr/bin/rm -rf $DIRBASE/{*,tar}
            exit 0
        fi
    done
else
    BKPFILETAR=$(/usr/bin/rclone lsf --include "*.tar" GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1)
    FILES=( $BKPFILETAR ) # Isso nem precisava, mas só queria deixar a coisas mais interessantes
    for i in "${FILES[@]}"
    do
        /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS "$DIRBASE"
    done
    /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILETAR"
    /usr/bin/rm -rf $DIRBASE/{*,tar}
    exit 0
fi