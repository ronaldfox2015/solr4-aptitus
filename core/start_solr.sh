#!/bin/bash

SOLR_DIR='/opt/solr/multicore/'

## Copy cores
cp -ar . $SOLR_DIR ## Ruta del binario de Solr

## Setear variables
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBCONNECTION}/bdr37.orbis.pe:3306/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DATABASE}/db_aptitus4a_test/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBUSER}/usr_apt4a_dev/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBPASSWORD}/ntK0Myps7LidswYKL/g'
