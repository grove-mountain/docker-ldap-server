# LDAP Docker Server for local LDAP development

This is a basic extension of: https://github.com/osixia/docker-openldap

This is a quick and dirty localized LDAP server for using in demonstrations. One of the nicer benefits of using the OTS OpenLDAP server is that it automatically sets up the memberOf overlay.   This can help you troubleshoot LDAP connectivity issues customers may be having.

For the most part, you really don't have to do anything.

BE CAREFUL OPENING THIS TO THE WORLD!  It's designed for local development and shouldn't be a vector for attack, but be careful as the passwords are published on the internet.   

## Run it
To run the tool using Docker directly, use launch_ldap.sh
```
./launch_ldap.sh
```

When you're done just kill docker:
```
docker kill openldap
```

## Customize it

This repo ships with some pre-canned LDIF files to bootstrap the server when it comes up.   You can customize this by editing the *ldif_feed.yaml* file and running:

```
./create_ldif.sh
```

Alternately, you can just create another LDIF feed file and set the LDIF_FEED environment variable

```
LDIF_FEED=ourcorp_ldif_feed.yaml
./create_ldif.sh
```

Make sure that the LDAP_DOMAIN and LDAP_HOSTNAME environment variables match your new environment as well.
```
LDAP_DOMAIN=ourcorp.com
LDAP_HOSTNAME=ldap.ourcorp.com
./launch_ldap.sh
```

## Test it

The passwords below are defaults sourced form the env.sh file, feel free to customize however you'd like.  

Example ldapsearch
Get all the things:
```
# It's from a mac, add Windows instructions please!
export IP_ADDRESS=$(ipconfig getifaddr en0)

ldapsearch -x -H ldap://${IP_ADDRESS} -b dc=ourcorp,dc=com \
-D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD}
```

Search for any user DNs that belong to cn=solutions_engineers,ou=group,dc=ourcorp,dc=com using memberOf overlay
```
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b dc=ourcorp,dc=com \
-D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} \
'(memberOf=cn=rockstars,ou=um_group,dc=ourcorp,dc=com)' dn
```

## Advice

I highly recommend using [Apache Directory Studio](https://directory.apache.org/studio/) for navigating LDAP/AD.   You can use the endpoints above to configure a connection with ADS.   For viewing results, it makes life much easier.   You can do some work via ADS as well, but I suggest just killing the server and uploading newly minted LDIFs if you can work ephemerally.
