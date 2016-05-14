=========================
Dockerizing ElasticSearch
=========================

:Author: Vladimir Kozlovski
:Contact: inbox@vladkozlovski.com
:Issues: https://github.com/kozlovskistudio/docker-elasticsearch/issues
:Docker image: https://hub.docker.com/r/kozlovskistudio/elasticsearch/
:Description: Dockerfile to build a ElasticSearch container image which can be 
              linked to other containers.

:Release notes: https://github.com/elastic/elasticsearch/releases
:Official image: https://hub.docker.com/_/elasticsearch/
:Official GitHub: https://github.com/elastic/elasticsearch


.. meta::
   :keywords: ElasticSearch, Docker, Dockerizing
   :description lang=en: Dockerfile to build a ElasticSearch container image which 
                         can be linked to other containers.

.. contents:: Table of Contents



Introduction
============

Dockerfile to build a ElasticSearch container image which can be linked to other 
containers.


Installation
============

Pull the latest version of the image from the docker index. This is the 
recommended method of installation as it is easier to update image in the 
future.
::
    docker pull kozlovskistudio/elasticsearch:latest

Alternately you can build the image yourself.
::
    git clone https://github.com/kozlovskistudio/docker-elasticsearch.git
    cd docker-elasticsearch
    docker build -t="$USER/elasticsearch" .


Quick Start
===========
You can run the default `elasticsearch` command simply:
::
    docker run -d kozlovskistudio/elasticsearch

You can also pass in additional flags to `elasticsearch`:
::
    docker run -d kozlovskistudio/elasticsearch elasticsearch -Des.node.name="TestNode"

This image comes with a default set of configuration files for `elasticsearch`, but if you want to provide your own set of configuration files, you can do so via a volume mounted at `/usr/share/elasticsearch/config`:
::
    docker run -d -v "$PWD/config":/usr/share/elasticsearch/config kozlovskistudio/elasticsearch

This image is configured with a volume at `/usr/share/elasticsearch/data` to hold the persisted index data. Use that path if you would like to keep the data in a mounted volume:
::
    docker run -d -v "$PWD/esdata":/usr/share/elasticsearch/data kozlovskistudio/elasticsearch


Upgrading
=========
To upgrade to newer releases, simply follow this 3 step upgrade procedure.

* **Step 1:** Stop the currently running image::

    docker stop elasticsearch


* **Step 2:** Update the docker image::

    docker pull kozlovskistudio/elasticsearch:latest


* **Step 3:** Start the image::

    docker run -p 127.0.0.1:9200:9200 -p 127.0.0.1:9300:9300 --name elasticsearch -d kozlovskistudio/elasticsearch:latest