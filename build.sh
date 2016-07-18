#!/usr/bin/sh

####################################################################################################
# Note:
# we're not going to use Docker Compose because it, like Docker build, doesn't allow us to map
# volumes that are outside of the Docker build context, which means that we can't really use
# Compose's 'up' or 'start' commands. Since we can't really avail ourselves of Docker Compose capa-
# bilities fully, or even reasonably, we're not going to use it at all.
####################################################################################################

# Build the base image
docker build -t node-dood-base .

if [ ! -d "./applications" ]; then
    mkdir ./applications
fi

for application in "$@"
do
    echo Building: ${application}
    if [ ! -d "./applications/${application}" ]; then
        git clone https://github.com/${application} applications/${application}
    fi
    
    docker build -t ${application} ./applications/${application}

    docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
                  -v $(which docker):/usr/bin/docker \
                  ${application}
done
