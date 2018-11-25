# LDAP Docker for HashiCorp SEs

This is a quick and dirty localized LDAP server for using in demonstrations. One of the nicer benefits of using the OTS OpenLDAP server is that it automatically sets up the memberOf overlay.   This can help you troubleshoot LDAP connectivity issues customers may be having.

If you want to customize this, you can add any LDIF files you want into the ldif directory and they will be picked up on container start.

For the most part, you really don't have to do anything.


If you want to change the default password:
e.g.
```
export LDAP_PASSWD="this_is_a_terrible_password_42"
export LDAP_PASSWD_HASH=$(docker exec -it openldap slappasswd -h {SSHA} -s ${LDAP_PASSWD}| tr -d '\r\n')
./create_user_records.sh
```

To run the tool using Docker directly, use launch_ldap.sh
```
./launch_ldap.sh
```

If you want to add more users, you can add them to the users.csv file.   Currently that also adds everyone to the solutions_engineering group, so that may not be favorable.   Feel free to add your own groups.   

When you're done just kill docker:
```
docker kill openldap
```
