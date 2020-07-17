. env.sh
. demo-magic.sh -d -p -w ${DEMO_WAIT}

export IP_ADDRESS=$(ipconfig getifaddr en0)

cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD}
EOF
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD}
p

cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=posix_group,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD}
EOF
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b ou=posix_group,dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD}
p

cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=posix_group,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD} \\
  '(cn=admins)'
EOF
echo
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b ou=posix_group,dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} '(cn=admins)'

p
cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=posix_group,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD} \\
  '(cn=admins)' \\
  memberUid
EOF
echo
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b ou=posix_group,dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} '(cn=admins)' memberUid

p
cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=posix_group,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD} \\
  '(cn=admins)' \\
  memberUid +
EOF
echo
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b ou=posix_group,dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} '(cn=admins)' memberUid +

p
cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=people,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD} \\
  '(memberOf=cn=rockstars,ou=um_group,dc=ourcorp,dc=com)' +
EOF
echo
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b ou=people,dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} '(memberOf=cn=rockstars,ou=um_group,dc=ourcorp,dc=com)' +

p
cat << EOF
ldapsearch -LLL -x -H ldap://${IP_ADDRESS} \\
  -b ou=people,dc=ourcorp,dc=com \\
  -D "cn=read-only,dc=ourcorp,dc=com" \\
  -w ${LDAP_READONLY_USER_PASSWORD} \\
  '(memberOf=cn=founders,ou=um_group,dc=ourcorp,dc=com)' \\
  dn
EOF
echo
p

ldapsearch -LLL -x -H ldap://${IP_ADDRESS} -b dc=ourcorp,dc=com -D "cn=read-only,dc=ourcorp,dc=com" -w ${LDAP_READONLY_USER_PASSWORD} '(memberOf=cn=founders,ou=um_group,dc=ourcorp,dc=com)' dn

