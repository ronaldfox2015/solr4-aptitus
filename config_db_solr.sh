#!/bin/bash

SOLR_DBCONNECTION=$1
SOLR_DATABASE=$2
SOLR_DBUSER=$3
SOLR_DBPASSWORD=$4
ENV=$5
## Setear variables
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBCONNECTION}/'${SOLR_DBCONNECTION}'/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DATABASE}/'${SOLR_DATABASE}'/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBUSER}/'${SOLR_DBUSER}'/g'
find $SOLR_DIR -name data-config.xml -type f -print0 | xargs -0 sed -i 's/{SOLR_DBPASSWORD}/'${SOLR_DBPASSWORD}'/g'
