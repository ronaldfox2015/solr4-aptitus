#!/bin/sh

SOLR_DATABASE=$1
SOLR_DBUSER=$2
SOLR_DBPASSWORD=$3
ENV=$4
BRANCH=$5

echo "postulante
aviso
aptitud
carrera
institucion
post_adquirido
puesto
programas
ubigeo" > /tmp/cores.tmp

while read line
do
    sed -i 's/{SOLR_DBCONNECTION}/mysql.'${ENV}'.aptitus.local:3306/g' src/solr/$line/conf/data-config.xml
    sed -i 's/{SOLR_DATABASE}/'${SOLR_DATABASE}'/g' src/solr/${line}/conf/data-config.xml
    sed -i 's/{SOLR_DBUSER}/'${SOLR_DBUSER}'/g' src/solr/${line}/conf/data-config.xml
    sed -i 's/{SOLR_DBPASSWORD}/'${SOLR_DBPASSWORD}'/g' src/solr/${line}/conf/data-config.xml
    time rsync -avzr src/solr/$line/conf/ root@solr4.${ENV}.aptitus.local:/var/lib/solr/${BRANCH}/solr/$line/conf
    curl "https://solr4.aptitus.com/solr/admin/cores?wt=json&action=RELOAD&core=$line"
done < /tmp/cores.tmp

rm -rf /tmp/cores.tmp
