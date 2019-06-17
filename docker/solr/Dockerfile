FROM openjdk:8-jre

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install lsof groovy2 && \
  mkdir -p /opt

ENV SOLR_VERSION 4.6.0
ENV SOLR solr-$SOLR_VERSION

RUN curl --retry 3 http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz | tar -C /opt --extract --gzip
RUN mv /opt/$SOLR /opt/solr

RUN wget -qO- https://downloads.mysql.com/archives/get/file/mysql-connector-java-5.1.26.tar.gz | tar xvz -C /opt && \
    mv /opt/mysql-connector-java-5.1.26/mysql-connector-java-5.1.26-bin.jar /opt/solr/example/lib/
    
RUN useradd --home-dir /opt/solr --comment "Solr Server" solr

RUN chown -R solr:solr /opt/solr/example

RUN mkdir -p /solr/apps/solr/home

RUN ln -s /opt/solr/example/lib/ /solr/apps/solr/home/

USER solr

EXPOSE 8983
WORKDIR /opt/solr/example

CMD ["java", "-Dsolr.solr.home=multicore", "-jar", "start.jar"]