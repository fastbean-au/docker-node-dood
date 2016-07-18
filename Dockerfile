FROM node
 
MAINTAINER fastbean-au <fastbean_au@yahoo.com.au>

USER root
RUN apt-get update \
    && apt-get install -y sudo \
    && mkdir /application

WORKDIR /application

CMD npm start