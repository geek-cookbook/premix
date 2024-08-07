#!/bin/bash

for role in `ls ansible/roles`
do
    echo $role | grep -q -E "docker-stack|helm-chart|proxmox" || sed "s/ROLE/$role/" .github/workflows/role.template > .github/workflows/role-$role.yml
done
