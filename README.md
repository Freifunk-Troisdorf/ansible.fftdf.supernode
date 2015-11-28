# ansible.fftdf.supernode
Ansible yml file to manage Freifunk Troisdorf supernodes

At this time you have to start it explicit with the target server
example: ansible-playbook install.sn.yml --extra-vars "target=troisdorf5"

You need this information in your hosts (/etc/ansible/hosts) file:
#example, I hope self explaining
[troisdorf5]
78.46.233.212

[troisdorf5:vars]
sn_hostname=troisdorf5
sn_dhcp_range=10.188.115.1 10.188.115.254
sn_dhcp_dns=10.188.1.100, 10.188.1.23
sn_dhcp_router=10.188.255.5
sn_mesh_IPv6=fda0:747e:ab29:7405:255::5
sn_mesh_IPv4=10.188.255.5
sn_mesh_MAC=a2:8c:ae:6f:f6:05
sn_fqdn=freifunk-troisdorf.de
sn_l2tp_tb_port=53844
