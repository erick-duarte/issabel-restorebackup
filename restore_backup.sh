#!/bin/bash

CLIENTE=$1
FILIAL=$2
DIRBASE="/var/www/backup/"

## PT - Isso foi criado pois alguns clientes especifico tem mais de um servidor(filial)
## EN - This was created because some specific clients have more than one server (branch)
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
            BKPFILESQL=$(/usr/bin/rclone lsf --include "*.sql" GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1)
            FILES=( $BKPFILETAR $BKPFILESQL ) # Isso nem precisava, mas só queria deixar a coisas mais interessantes
            for i in "${FILES[@]}"
            do
                /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS "$DIRBASE"
            done
            /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILETAR"
            if [ -f $DIRBASE/ARQUIVOSQL.sql ]
            then
                /usr/bin/echo "create database DB;"|/usr/bin/mysql -u root -pSENHA
                /usr/bin/mysql -u root -pSENHA DB < $DIRBASE/ARQUIVOSQL.sql
            fi
            /usr/bin/rm -rf $DIRBASE/{*.sql,*,tar}
            exit 0
        fi
    done
else
    BKPFILETAR=$(/usr/bin/rclone lsf --include "*.tar" GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1)
    BKPFILESQL=$(/usr/bin/rclone lsf --include "*.sql" GOOGLEDRIVE:DIRETORIOS | /usr/bin/head -n 1)
    FILES=( $BKPFILETAR $BKPFILESQL ) # Isso nem precisava, mas só queria deixar a coisas mais interessantes
    for i in "${FILES[@]}"
    do
        /usr/bin/rclone copy GOOGLEDRIVE:DIRETORIOS "$DIRBASE"
    done
    /usr/share/issabel/privileged/backupengine --restore --backupfile="$BKPFILETAR"
    if [ -f $DIRBASE/ura_rever*.sql ]
    then
        /usr/bin/echo "create database DB;"|/usr/bin/mysql -u root -pSENHA
        /usr/bin/mysql -u root -pSENHA DB < $DIRBASE/ura_rever*.sql
    fi
    /usr/bin/rm -rf $DIRBASE/{*.sql,*,tar}
    exit 0
fi
