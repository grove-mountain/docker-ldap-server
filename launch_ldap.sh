DOCKER_VERSION=1.2.2
LDAP_ORGANISATION="HashiCorp Inc"
LDAP_DOMAIN="hashidemos.com"
LDAP_ADMIN_PASSWORD="hashifolk"
LDAP_HOSTNAME="ldap.hashidemos.com"

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
  -v ${DIR}/ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom \
  --name openldap \
  --detach osixia/openldap:${DOCKER_VERSION} --copy-service --loglevel debug
