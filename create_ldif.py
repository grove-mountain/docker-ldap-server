# This reads in the ldif_feed.yaml file and spits out all the necessary
# LDIF files to bootstrap the LDAP system.  

#from jinja2 import Environment, PackageLoader, Template, select_autoescape
from jinja2 import Template
import yaml

input_file="input.yaml"
def parse_yaml(input_file):
    with open(input_file, 'r') as INPUT:
        try:
            context = yaml.load(INPUT)
        except yaml.YAMLError as err:
            print("Error in configuration file: {}".format(err))
        except (OSError, IOError) as err:
            print("File not found: {}".format(err))
    return context

def create_ou_ldif(ou_list, base_dn, output_file="ou.ldif"):
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

def create_people_ldif(people_list, base_dn, output_file="people.ldif")
    default_password="{SSHA}TZxtCI87FgRXt051Dd4lFCc9XXktY5Qx"
    template=Template("""
dn: cn={{ uid }},ou=people,{{ base_dn }}
cn: {{ uid }}
sn: {{ last }}
givenName: {{ first }}
homeDirectory: /home/{{ uid }}
uid: {{ uid }}
uidNumber: {{ uid_num }}
gidNumber: {{ gid_num }}
objectClass: person
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
userPassword: {{ password }}

""")

def print_file(input_file):
    """Helper for verifying output files"""
    with open(input_file, 'r') as INPUT:
        for line in INPUT:
            print(line)

for k, v in context['people'].items():
    uid = k
    for um in v['um_groups']:
        um_group.add(um, uid)

class Groups:
    """Holds all group information with users
    group_type: The LDAP object type this group represents"""
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
{% for member in members %}
memberUid: {{ member }}
{% endfor %}
""")
    def __init__(self, group_type, base_dn, start_gid=1000): 
        """Initialize a dictionary to hold keys for the group name and a list
        for the members.  
        group_type in ['um', 'posix']
        start_gid is only used for posix groups"""
        self.group_type = group_type
        self.gid = start_gid
        self.base_dn = base_dn
        self.group_dict = {}
        self.output_file = "{}_groups.ldif".format(group_type)
    def add(self, group, member):
        try:
            self.group_dict[group].append(member)
        except KeyError:
            self.group_dict[group] = [member]
    def render(self):
        with open(self.output_file, 'w') as OF:
            for name, members in self.group_dict.items():
                if self.group_type == 'um':
                    OF.write(um_template.render(name=name, base_dn=base_dn,
                                                members=members))
                if self.group_type == 'posix'
                    OF.write(posix_template.render(name=name,
                                                   base_dn=base_dn,
                                                   members=members,
                                                   gid=self.gid)
                    self.gid++

