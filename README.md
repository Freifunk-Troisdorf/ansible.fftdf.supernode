Ansible file to manage Freifunk Troisdorf supernodes
example: ansible-playbook install.sn.yml -l hosts

To install a individual host you have to start it explicit with the target server
example: ansible-playbook install.sn.yml -l hosts -l troisdorf7 -v

The hosts file is the most important file.

You will find some example files:
files/hosts.example
files/root_pwd.yml.example
files/slack_token.yml.example
