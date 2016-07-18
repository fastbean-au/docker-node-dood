FROM node
 
MAINTAINER fastbean-au <fastbeanau@gmail.com>

USER root
RUN apt-get update \
    && apt-get install -y sudo \
    && mkdir /application

WORKDIR /application

CMD npm start