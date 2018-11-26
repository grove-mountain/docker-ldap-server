# This reads in the ldif_feed.yaml file and spits out all the necessary
# LDIF files to bootstrap the LDAP system.  
# Runs in a Docker container so you don't have to worry about dependencies

DOCKER_IMAGE=grovemountain/ldap_ldif_builder:latest
echo "Pulling Docker Image"
docker pull ${DOCKER_IMAGE} &> /dev/null
echo "Creating LDIF files"
docker run \
  -v ${PWD}/ldif_feed.yaml:/app/ldif_feed.yaml \
  -v ${PWD}/ldif:/app/ldif \
  --rm ${DOCKER_IMAGE} &> /dev/null
