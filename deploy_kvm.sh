#!/bin/bash
set -xe

if [[ -z $1 ]]; then
    echo "Usage ./deploy_kvm.sh env_file"
    exit 1
fi

if [[ -f defaults/main.yml ]]; then
    echo "Cleaning up old file"
    rm defaults/main.yml
fi
source $1
cat <<YAML > defaults/main.yml
# KVM config
kvm_vm_pool_dir: '${vm_pool}'
kvm_install_host: "${vm_host}"

# Cloud Init Config
vm_data_dir: ${vm_data_dir}
vm_recreate: ${recreate_vm}
cloud_init_vm_image: ${vm_image}
cloud_init_vm_image_link: "${vm_image_link}"
# Latest image is from https://cloud.centos.org/centos/7/images/

cloud_init_user_data: "{{ vm_data_dir }}/{{ vm_name }}/user-data"
cloud_init_meta_data: "{{ vm_data_dir }}/{{ vm_name }}/meta-data"
cloud_init_iso_image: "{{ vm_data_dir }}/{{ vm_name }}/cidata.iso"

vm_name: ${vm_name}
vm_local_hostname: ${vm_localhost_name}
vm_hostname: ${vm_hostname}
vm_public_key: "{{ lookup('file', '${public_key_location}') }}"
vm_cpu: ${vcpu_count}
vm_memory: ${memory_count}
vm_root_disk_size: ${vm_disk_size}

YAML
