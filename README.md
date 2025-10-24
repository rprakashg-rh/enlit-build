# Enlit 2025 build
This repo contains all artifacts used for build of enlit 2025 demos

## Building the ISO file for unattended installation of RHEL 9.6 on virtualization host

Request an AWS Open environment from demo.redhat.com and create an EC2 instance using the RHEL 9 AMI provided by Red Hat from the AWS console. We are going to use this host as image builder to build a custom ISO we can use to do unattended install of RHEL 9. Verify that host is up and running and that you can SSH into it.

Connect the system to Red Hat by running command below

```sh
sudo rhc connect -u <redacted> -p <redacted>
```

Ensure all current updates are applied to RPM packages by running command below

```sh
sudo dnf upgrade
```

Install infra.osbuild collection from ansible galaxy by running command below

```sh
ansible-galaxy collection install infra.osbuild
```

Create an inventory file and add the snippet below, replace as needed.
```sh
---
all:
  hosts:
    imagebuilder:
      ansible_host: "<specify>"
      ansible_port: 22
      ansible_user: "ec2-user"
      ansible_ssh_private_key_file: "<specify>"

```

Run ansible playbook to setup the imagebuilder server as shown in the command below

```sh
ansible-playbook -i inventory setup-imagebuilder.yml
```

To build ISO run build_iso.yml playbook as shown below

```sh
ansible-playbook -i inventory build_iso.yml
```
