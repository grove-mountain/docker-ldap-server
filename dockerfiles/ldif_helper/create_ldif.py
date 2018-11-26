# This reads in the ldif_feed.yaml file and spits out all the necessary
# LDIF files to bootstrap the LDAP system.  

#from jinja2 import Environment, PackageLoader, Template, select_autoescape
from jinja2 import Template
import yaml

input_file="ldif_feed.yaml"
default_password="{SSHA}TZxtCI87FgRXt051Dd4lFCc9XXktY5Qx"
start_uid=1000
start_gid=1000

um_template=Template("""
dn: cn={{ name }},ou=um_group,{{ base_dn }}
objectClass: groupOfUniqueNames
objectClass: top
cn: {{ name }}
{% for member in members -%}
uniqueMember: {{ member }}
{% endfor %}
""")

posix_template=Template("""
dn: cn={{ name }},ou=posix_group,{{ base_dn }}
objectClass: posixGroup
objectClass: top
cn: {{ name }}
gidNumber: {{ gid }}
{% for member in members -%}
memberUid: {{ member }}
{% endfor %}
""")

def main():
    global um_groups
    global posix_groups
    context = parse_yaml(input_file)
    base_dn = context['base_dn']
    ou_list = context['ou']
    um_groups = Groups('um', base_dn)
    posix_groups = Groups('posix', base_dn)
    create_ou_ldif(ou_list, base_dn)
    people_dict = context['people']
    create_people_ldif(people_dict, base_dn)
    um_groups.render()
    posix_groups.render()

def parse_yaml(input_file):
    with open(input_file, 'r') as INPUT:
        try:
            context = yaml.load(INPUT)
        except yaml.YAMLError as err:
            print("Error in configuration file: {}".format(err))
        except (OSError, IOError) as err:
            print("File not found: {}".format(err))
    return context

def create_ou_ldif(ou_list, base_dn, output_file="ldif/0_ou.ldif"):
    """Takes a list of dictionaries with name/path pairs and outputs LDIF to
create OUs"""
    template=Template("""
dn: {{ path }},{{ base_dn }}
objectClass: organizationalUnit
objectClass: top
ou: {{ name }}

""")
    with open(output_file, 'w') as OF:
        for unit in ou_list:
            OF.write(template.render(unit, base_dn=base_dn))

def create_people_ldif(people_dict, base_dn, start_uid=start_uid,
                       output_file="ldif/1_people.ldif"):
    template=Template("""
dn: cn={{ uid }},ou=people,{{ base_dn }}
objectClass: person
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
cn: {{ uid }}
sn: {{ last }}
givenName: {{ first }}
homeDirectory: /home/{{ uid }}
uid: {{ uid }}
uidNumber: {{ uid_num }}
gidNumber: {{ gid_num }}
mail: {{ email }}                      
userPassword: {{ password }}

""")
    uid_num = start_uid
    with open(output_file, 'w') as OF:
        for uid, values in people_dict.items():
            # Add any group memberships to the appropriate group objects
            dn = "cn={},ou=people,{}".format(uid, base_dn)
            for um in values['um_groups']:
                um_groups.add(um, dn)
            for posix in values['posix_groups']:
                posix_groups.add(posix, dn)
            # If someone set the passsword, use it, otherwise use the default
            try:
                password=values['password']
            except KeyError:
                password=default_password
            try:
                gid_num=values['gid_num']
            except KeyError:
                gid_num=start_gid

            OF.write(template.render(values, base_dn=base_dn, uid=uid, 
                                     uid_num=uid_num, gid_num=gid_num, 
                                     password=password))
            uid_num+=1


def print_file(input_file):
    """Helper for verifying output files"""
    with open(input_file, 'r') as INPUT:
        for line in INPUT:
            print(line)

class Groups:
    """Holds all group information with users
    group_type: The LDAP object type this group represents"""
    def __init__(self, group_type, base_dn, start_gid=start_gid): 
        """Initialize a dictionary to hold keys for the group name and a list
        for the members.  
        group_type in ['um', 'posix']
        start_gid is only used for posix groups"""
        self.group_type = group_type
        self.gid = start_gid
        self.base_dn = base_dn
        self.group_dict = {}
        self.output_file = "ldif/2_{}_groups.ldif".format(group_type)
    def add(self, group, member):
        try:
            self.group_dict[group].append(member)
        except KeyError:
            self.group_dict[group] = [member]
    def render(self):
        with open(self.output_file, 'w') as OF:
            for name, members in self.group_dict.items():
                if self.group_type == 'um':
                    OF.write(um_template.render(name=name, base_dn=self.base_dn,
                                                members=members))
                if self.group_type == 'posix':
                    OF.write(posix_template.render(name=name,
                                                   base_dn=self.base_dn,
                                                   members=members,
                                                   gid=self.gid))
                    self.gid+=1



if __name__ == "__main__":
    main()
