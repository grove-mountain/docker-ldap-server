# LDAP Docker for HashiCorp SEs

This is a basic extension of: https://github.com/osixia/docker-openldap

This is a quick and dirty localized LDAP server for using in demonstrations. One of the nicer benefits of using the OTS OpenLDAP server is that it automatically sets up the memberOf overlay.   This can help you troubleshoot LDAP connectivity issues customers may be having.

For the most part, you really don't have to do anything.

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

## Test it

The passwords below are defaults, so if you customize them, make sure to adjust appropriately.

Example ldapsearch
Get all the things:
```
# It's from a mac, add Windows instructions please!
export IP_ADDRESS=$(ipconfig getifaddr en0)

ldapsearch -x -H ldap://${IP_ADDRESS} -b dc=hashidemos,dc=com \
-D "cn=read-only,dc=hashidemos,dc=com" -w ${LDAP_READONLY_USER_PASSWORD}
```

Search for any user DNs that belong to cn=solutions_engineers,ou=group,dc=hashidemos,dc=com using memberOf overlay
```
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b dc=hashidemos,dc=com \
-D "cn=read-only,dc=hashidemos,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} \
'(memberOf=cn=solutions_engineering,ou=um_group,dc=hashidemos,dc=com)' dn
```

## Advice

I highly recommend using [Apache Directory Studio](https://directory.apache.org/studio/) for navigating LDAP/AD.   You can use the endpoints above to configure a connection with ADS.   For viewing results, it makes life much easier.   You can do some work via ADS as well, but I suggest just killing the server and uploading newly minted LDIFs if you can work ephemerally.
