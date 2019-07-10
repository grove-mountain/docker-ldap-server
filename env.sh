DOCKER_VERSION=1.2.2
LDAP_ORGANISATION=${LDAP_ORGANISATION:-"OurCorp Inc"}
LDAP_DOMAIN=${LDAP_DOMAIN:-"ourcorp.com"}
LDAP_HOSTNAME=${LDAP_HOSTNAME:-"ldap.ourcorp.com"}
LDAP_READONLY_USER=${LDAP_READONLY_USER:-true}
LDAP_READONLY_USER_USERNAME=${LDAP_READONLY_USER_USERNAME:-read-only}
export LDAP_READONLY_USER_PASSWORD=${LDAP_READONLY_USER_PASSWORD:-"devsecopsFTW"}
export LDAP_ADMIN_PASSWORD=${LDAP_ADMIN_PASSWORD:-"hashifolk"}
# This is the default user password created by the default ldif creator if none other is specified
export DEFAULT_USER_PASSWORD="thispasswordsucks"
