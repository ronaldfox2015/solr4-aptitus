#!/bin/sh

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
    time rsync -avzr $(PWD)/core/$line/conf/ root@solr4.${ENV}.aptitus.local:/var/lib/solr/${BRANCH}/solr/$line/conf
    curl "https://solr4.aptitus.com/solr/admin/cores?wt=json&action=RELOAD&core=$line"    
done < /tmp/cores.tmp

rm -rf /tmp/cores.tmp
