# Docker-Node-DooD

A NodeJS Docker-out-of-Docker helper.  The DooD aspect was taken pretty much directly from http://container-solutions.com/running-docker-in-jenkins-in-docker/.

Useful for when you need a Docker container or containers to interact with Docker, including the creation of other Docker containers.

## Usage

### Creating Docker containers

The bash script _build.sh_ is used to create a base application image, and one or more applications as passed on the command line.  The applications can either already exist within a _./applications_ directory, or can be GitHub repositories (using the form of organisation/repo or user/repo), or a mixture of both.

E.g.:

```bash
./build.sh fastbeanau/my-app-persistence-layer fastbeanau/my-app-api-layer fastbeanau/my-app-ui-layer 
```

But, that is a rather contrived example, as there is probably little reason for the UI layer to need access to Docker, and neither the persistence layer would likely require Docker access nor NodeJS, and thus both of those would be unsuitable for this. 

Applications making use of this image are expected to include something similar to the following in their Dockerfile:

```bash
FROM node-dood-base

COPY  . /application/

RUN cd /application \
    && npm install --production
```

### Node Utilities

A Node script containing a helper method is also included in this repository (and published to NPM as dood-utils). 

```bash
npm install dood-utils
```

Within your scripts:

```javascript
const dood = require('dood-utils');
const myLocalPort = 8888;

dood.getHostPortMappings((err, ports) => {
  console.log(`Server listening on local port ${ports[myLocalPort+'/tcp'][0].HostPort}`);
});
```

## Notes

* Any ports exposed by the container will be randomly mapped and exposed on the Docker host. This mapping _will_ change on container start & restart, you may wish to consider using a discovery/registry service if this is an issue.  The NPM package dood-utils has a method to provide the current port mappings to the container. 

* Specific configuration settings for individual container(s) (once created) can be set by using the [docker update](https://docs.docker.com/engine/reference/commandline/update/) command, e.g.

```bash
docker update --restart=unless-stopped my-app-persistence-layer
docker update --restart=on-failure:10 my-app-api-layer my-app-ui-layer
```
