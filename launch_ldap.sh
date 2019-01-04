# 
DOCKER_VERSION=1.2.2
LDAP_ORGANISATION=${LDAP_ORGANISATION:-"HashiCorp Inc"}
LDAP_DOMAIN=${LDAP_DOMAIN:-"hashidemos.com"}
LDAP_HOSTNAME=${LDAP_HOSTNAME:-"ldap.hashidemos.com"}
LDAP_READONLY_USER=${LDAP_READONLY_USER:-true}
LDAP_READONLY_USER_USERNAME=${LDAP_READONLY_USER_USERNAME:-read-only}
export LDAP_READONLY_USER_PASSWORD=${LDAP_READONLY_USER_PASSWORD:-"devsecopsFTW"}
export LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD:-"hashifolk"}
# This is the default user password created by the default ldif creator if none other is specified
export DEFAULT_USER_PASSWORD="thispasswordsucks"

# Get the relative directory name
# Sorry windows folks, you're gonna have to figure this out and modify it for you pleasure
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

docker rm openldap
docker run --hostname ${LDAP_HOSTNAME} \
  -p 389:389 \
  -p 689:689 \
  -e LDAP_ORGANISATION="${LDAP_ORGANISATION}" \
  -e LDAP_DOMAIN="${LDAP_DOMAIN}" \
  -e LDAP_ADMIN_PASSWORD="${LDAP_ADMIN_PASSWORD}" \
  -e LDAP_READONLY_USER=${LDAP_READONLY_USER} \
  -e LDAP_READONLY_USER_USERNAME=${LDAP_READONLY_USER_USERNAME} \
  -e LDAP_READONLY_USER_PASSWORD=${LDAP_READONLY_USER_PASSWORD} \
  -v ${DIR}/ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom \
  --name openldap \
  --detach osixia/openldap:${DOCKER_VERSION} --copy-service
