# What is this?

This is the beginning of a set of Ansible roles / playbooks, providing automated, immutable roles to:

1. (Optionally) Create a Kubernetes cluster / Docker swarm using Proxmox 
2. Deploy recipes to the above cluster / swarm

The goal is either to streamline testing of new recipes (in which case the VMs can be destroyed when complete), or to stand up a completely automated environment.

# Requirements

You'll need, for your environment:

1. [Terraform](https://www.terraform.io)
2. [Terraform proxmox provider](https://github.com/Telmate/terraform-provider-proxmox)
3. [Ansible](https://www.ansible.com)

# How to use it

I expect this section will grow as we progress, but at the very least:

## Setup your vault

We'll need to store some secrets, like your proxmox admin credentials. We want to do this in a way which is safe from accidental git commits, as well as convenient for repeated iterations, without having to pass secrets as variables on the command-line.

Enter [Ansible Vault](https://docs.ansible.com/ansible/latest/user_guide/vault.html#creating-encrypted-files), a handy solution for encrypting secrets in a painless way.

1. Create a password file, containing your vault password, and store it _outside_ of the repo:

```
echo mysecretpassword > ~/.ansible/vault-password-geek-cookbook-premix
```

1. Create an ansible-vault encrypted file in the `vars/vault.yml` (*this file is .gitignored*) using this password file:

```
ansible-vault create --encrypt-vault-id geek-cookbook-premix vars/vault.yml
```

3. Insert your secret values into this file (*refer to `group_vars/all/01_fake_vault.yml` for placeholders*), using a prefix of `vault_`, like this:

```
vault_proxmox_host_password: mysekritpassword
```

(You can always re-edit the file by running `ansible-vault edit vars/vault.yml`)


## Populate hosts file

Copy `hosts.example` to `hosts`, and customize it for your own environment (`hosts` is ignored by `.gitignore`). Comment out the sections you're not going to use (*i.e., either k3s or swarm*)

## Deploy

Run the playbook by executing `ansible-playbook -i hosts deploy.yml`

## Destroy (with caution)

Running  `ansible-playbook -i hosts carefully_destroy.yml` will **remove** your VMs and **destroy** any data on them

# How to get help

Jump into #dev in http://chat.funkypenguin.co.nz and shout loudly :)
