# Assignment1

This Repo Contains all Terraform resources and Ansible playbook to setup 3 node mongodb-replicaset

- Terraform run provisions 3 node mongodb-replicaset
- Ansible run configures 3 node mongodb-replicaset and intiates replica with mongodb-exporter and node-exporter enabled.

Playbook tested against ubuntu-18.04 & ubuntu-20.04

## Folder-Structure

```txt
├── ansible
│   ├── hosts.yml
│   ├── playbooks
│   │   ├── mongodb_replicaset.yml
│   │   ├── tasks
│   │   │   ├── install-basic.yml
│   │   │   └── node-exporter.yml
│   │   └── templates
│   │       └── node_exporter.service.j2
│   └── roles
│       └── mongodb_replica
│           ├── defaults
│           │   └── main.yml
│           ├── handlers
│           │   └── main.yml
│           ├── tasks
│           │   ├── configure-mongodb.yml
│           │   ├── install-mongodb.yml
│           │   ├── main.yml
│           │   ├── prometheus-mongodb-exporter.yml
│           │   └── replication.yml
│           └── templates
│               ├── mongod.conf.j2
│               └── prometheus-mongodb-exporter.j2
├── ansible.cfg
└── terraform
    ├── main.tf
    ├── providers.tf
    └── variables.tf
```

## Sample Ansible-Inventory Format

```yml
all:
  vars:
    ansible_user: ubuntu
    node_exporter_version: 1.1.2
    basic_packages:
      - name: tmux
        state: present
      - name: htop
        state: present
      - name: s3fs
        state: present

  children:
    master:
      hosts:
        mongo-rs-01:
          ansible_host:
    replica:
      hosts:
        mongo-rs-02:
          ansible_host:
        mongo-rs-03:
          ansible_host:
```

## Default_ports

```yml
mongod_port: 27017
mongodb_exporter_port: 9200
prometheus_node_exporter: 9100
```

## To add/remove ingress rule

```yml
# modify in terraform/variables.tf
variable "ingress_rules" {
  type = map(map(any))
  default = {
    rule1 = { from = 22, to = 22, protocol = "tcp", cidr = "0.0.0.0/0", description = "ssh" }
    rule2 = { from = 27017, to = 27017, protocol = "tcp", cidr = "0.0.0.0/0", description = "mongodb" }
  }
}
```

## To modify vm_name and size 

```yml
# modify in terraform/variables.tf
variable "instances" {
  type = map(map(any))
  default = {
    instance1 = { name = "mongo-rs-01", type = "t2.micro" }
    instance2 = { name = "mongo-rs-02", type = "t2.micro" }
    instance3 = { name = "mongo-rs-03", type = "t2.micro" }
  }
}
```

### To run Ansible playbook

```sh
ansible-playbook run -i ansible/hosts.yml ansible/mongodb_replicaset.yml 
```

### Tags to run tasks individualy

```yml
--tags basic_setup  #to run dependency installation task
--tags mongodb #to run mongodb role
--tags node_exporter #to setup prometheus node exporter
```

### To add/remove dependency

```yml
basic_packages:
      - name: tmux
        state: present #change this to absent to remove

ruby: present #change this to absent to remove ruby
```
### Ansible Run Report for ubuntu-20.04

```txt
PLAY RECAP ****************************************************************************************************
mongo-rs-01                : ok=33   changed=23   unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   
mongo-rs-02                : ok=30   changed=20   unreachable=0    failed=0    skipped=4    rescued=0    ignored=0   
mongo-rs-03                : ok=30   changed=20   unreachable=0    failed=0    skipped=4    rescued=0    ignored=0   

Playbook run took 0 days, 0 hours, 5 minutes, 23 seconds
Friday 22 July 2022  01:10:54 +0530 (0:00:01.657)       0:05:23.359 *********** 
=============================================================================== 
BASIC_SETUP | Upgrading all packages ----------------------------------------------------------------- 115.51s
../../roles/mongodb_replica : Ensure pip is installed ------------------------------------------------- 41.83s
BASIC_SETUP | APT: Install aptitude package ----------------------------------------------------------- 33.95s
../../roles/mongodb_replica : INSTALL MONGODB | Install MongoDB Packages ------------------------------ 19.39s
BASIC_SETUP | Install a few basic packages ------------------------------------------------------------ 12.79s
../../roles/mongodb_replica : INTIALIZE REPLICA | Wait for replicaset to converge --------------------- 12.36s
BASIC_SETUP |Install ruby ----------------------------------------------------------------------------- 10.47s
BASIC_SETUP |PPA and install its signing key ----------------------------------------------------------- 9.36s
../../roles/mongodb_replica : MONGODB-EXPORTER | download node exporter -------------------------------- 9.02s
../../roles/mongodb_replica : INSTALL MONGODB | Ensure MongoDB apt repository exists ------------------- 7.21s
NODE EXPORTER | download node exporter ----------------------------------------------------------------- 5.17s
../../roles/mongodb_replica : INSTALL MONGODB | Install debian packages -------------------------------- 4.69s
../../roles/mongodb_replica : Ensure pymongo is installed ---------------------------------------------- 4.64s
Gathering Facts ---------------------------------------------------------------------------------------- 4.48s
../../roles/mongodb_replica : INSTALL MONGODB | Add apt key for MongoDB repository --------------------- 4.47s
../../roles/mongodb_replica : MONGODB-EXPORTER | configure prometheus-mongodb-exporter ----------------- 3.13s
NODE EXPORTER |unarchive node exporter ----------------------------------------------------------------- 3.07s
../../roles/mongodb_replica : CONFIGURE_MONGODB | Copy config file ------------------------------------- 3.05s
../../roles/mongodb_replica : CONFIGURE_MONGODB | Copy keyfile to host --------------------------------- 2.98s
NODE EXPORTER | install unit file to systemd ----------------------------------------------------------- 2.93s
```
