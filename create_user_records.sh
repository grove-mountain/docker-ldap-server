UID_NUMBER=5000
GID_NUMBER=5000
USER_LDIF=ldif/1_people.ldif
GROUP_LDIF=ldif/2_se_group.ldif
EMAIL_DOMAIN=${EMAIL_DOMAIN:-hashicorp.com}
# default is hashed of this_is_a_terrible_password_42
LDAP_PASSWD_HASH=${LDAP_PASSWD_HASH:-"{SSHA}AlgJ/vKO/RlhOoNhdSeTQKSpq+8HWpe7"}

# Start clean with new files
rm -f ${USER_LDIF} ${GROUP_LDIF}

cat >> ${GROUP_LDIF} << EOF
dn: cn=solutions_engineers,ou=group,dc=hashidemos,dc=com
objectClass: groupOfUniqueNames
objectClass: top
cn: solutions_engineers
EOF

cat users.csv | while IFS=, read uid first last; do 
if [[ $uid == *"#"* ]]; then
  continue
fi
DN="cn=$uid,ou=people,dc=hashidemos,dc=com"
cat >> ${USER_LDIF} << EOF
dn: ${DN}
cn: $uid
sn: $last
givenName: $first
homeDirectory: /home/$uid
uid: $uid
uidNumber: ${UID_NUMBER}
gidNumber: ${GID_NUMBER}
objectClass: person
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
userPassword: ${LDAP_PASSWD_HASH}

EOF

echo "uniqueMember: ${DN}" >> ${GROUP_LDIF}

((UID_NUMBER++))
done
