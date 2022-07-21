# Assignment1

Contains all Terraform resources and Ansible playbook to setup mongodb-replicaset

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

## To open Ports

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

### To add/remove dependency

```yml
basic_packages:
      - name: tmux
        state: present #change this to absent to remove

ruby: present #change this to absent to remove ruby
```
