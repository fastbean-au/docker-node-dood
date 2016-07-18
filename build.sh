#!/usr/bin/sh

####################################################################################################
# Note:
# we're not going to use Docker Compose because it, like Docker build, doesn't allow us to map
# volumes that are outside of the Docker build context, which means that we can't really use
# Compose's 'up' or 'start' commands. Since we can't really avail ourselves of Docker Compose capa-
# bilities fully, or even reasonably, we're not going to use it at all.
####################################################################################################

####################################################################################################
# Build the base image
docker build -t node-dood-base .

if [ ! -d "./applications" ]; then
    mkdir ./applications
fi

####################################################################################################
# Build and run each application
for application in "$@"
do
    echo Building: ${application}
    if [ ! -d "./applications/${application}" ]; then
        git clone https://github.com/${application} applications/${application}
    fi
    
    docker build --no-cache -t ${application} ./applications/${application}

    IFS='/' read -ra NAME <<< "$application"

    docker run -d -P --name ${NAME[-1]} \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v "$(which docker)":/usr/bin/docker \
               ${application}
done

####################################################################################################
# Display all port mappings for the applications 
echo
echo
for application in "$@"
do
    echo ================================================================================
    echo Port mappings for: ${application}
    IFS='/' read -ra NAME <<< "$application"
    docker port ${NAME[-1]}
done

echo
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Finsihed.
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
