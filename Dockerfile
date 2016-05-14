FROM debian:testing
MAINTAINER Vladimir Kozlovski <inbox@vladkozlovski.com>
ENV DEBIAN_FRONTEND noninteractive

ENV BUILD_DEPENDENCIES curl

RUN apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_DEPENDENCIES \
      openjdk-8-jre-headless && \
    rm -rf /var/lib/apt/lists/*


# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" && \
    curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" && \
    gpg --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu


ENV ELASTICSEARCH_VERSION 2.2.2
ENV ELASTICSEARCH_DOWNLOAD_URL https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r elasticsearch && \
    useradd -r -g elasticsearch elasticsearch

RUN mkdir -p /opt && \
    cd /tmp && \
    mkdir -p /usr/share/elasticsearch/plugins && \
    curl -SL "$ELASTICSEARCH_DOWNLOAD_URL" -o elasticsearch.tar.gz && \
    tar -xzf elasticsearch.tar.gz -C /usr/share/elasticsearch --strip-components=1 && \
    rm elasticsearch.tar.gz && \
    apt-get purge -y --auto-remove $BUILD_DEPENDENCIES


ENV PATH /usr/share/elasticsearch/bin:$PATH
COPY config /usr/share/elasticsearch/config

VOLUME /usr/share/elasticsearch/data

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9200 9300

CMD ["elasticsearch"]
