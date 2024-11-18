#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

OCP_SNO_INSTALL_HOME=ocp_sno_setup
OCP_SNO_SETUP_CLI_TOOLS=${OCP_SNO_INSTALL_HOME}/cli-tools
OCP_SNO_SSHKEYS=${OCP_SNO_INSTALL_HOME}/sshkey
OCP_SNO_KVM_SETUP=${OCP_SNO_INSTALL_HOME}/kvm
OCP_SNO_SECRETS=${OCP_SNO_INSTALL_HOME}/secrets
OCP_SNO_INSTALLER_FILES=${OCP_SNO_INSTALL_HOME}/installer-files

OCP_CLUSTER_NAME=ocp-sno2

VIRTUAL_VOLUME_NAME=ocp-sno2
TARGET_DISK_PARTITION=/mnt/ocp-sno
VIRTUAL_VOLUME_SIZE=370GiB

# Download Pull secret and paste here
OCP_PULL_SECRET='{"auths":{"cloud.openshift.com":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfOWI3NDhhNmYwNGQxNDE2YmI3MWQxNTRkM2EyMzQyMTc6UTdCRExMRTlGRzJUTVhHMzIxVU8yU0NGRjQ4ODVOVzNYMDVKWFJJNzAySUcxWFhCUU9VWDY3UkdNNlpMTkxRTw==","email":"marimuthuceo@gmail.com"},"quay.io":{"auth":"b3BlbnNoaWZ0LXJlbGVhc2UtZGV2K29jbV9hY2Nlc3NfOWI3NDhhNmYwNGQxNDE2YmI3MWQxNTRkM2EyMzQyMTc6UTdCRExMRTlGRzJUTVhHMzIxVU8yU0NGRjQ4ODVOVzNYMDVKWFJJNzAySUcxWFhCUU9VWDY3UkdNNlpMTkxRTw==","email":"marimuthuceo@gmail.com"},"registry.connect.redhat.com":{"auth":"fHVoYy1wb29sLWVkZTA5ZjVjLTJmYTctNDFmMS04ZDRiLTg2MmVmMTY3ZjFlNjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmlPV0pqTlRjMU5UVXhOemcwTlRjNVltRmlNalpqWXpnd09XRTVPRE5pWXlKOS5CNWRsNGEzbFJzUlU4UDh5cjJkUFpuc05uM1NwQjRNM3BCZ0ZrdzItaHJvbW1MYkwtYzVuMlpRdmZsa05iNVhrQ2hjdlh0Z0h0MVhRUXpGQmFiOWROd252Rk9oR1NFZ1kyVjZzeHVvTkNKTUYwQXJjZTZuaVAzN3JXb09YXzJCRTIyUmQzUVJ6MjRTREo4bEhMLURMNlZZOWVQRVVMdVhIUFB5b0xRZEJyWHNwMF90UmJkQ1hNSWYzcDNVTTlWcFoxOUlVdk9TbmJjWmRIa2VMVG5aWjZHOGM5MHdsWkV6WDdZa1NFbUpRY09FR2I4YVA4MVVPejg0WHloc2tZSXFyWlRyLVhSSGQ5dUpUNFZlclc3QVhCTWRHMlFkcnBwS1c2MlM3cjR5NjJyWndvLXROUWRRWDNGRzg0RXhmUjRrYUp0LU42QmdoZ3NWUlBVdEtVb1NrdUhmQWw5QzlZQWsyZXJGaHU2RkhEZmhjN25zQzNRSy1ucHZJREJjbGRoR2paS2YyVGoxSTBIQTBmTzlvUlVZdEhXZ0c3MWEwb191WFc4UnRUTHBBWWpkc0lBTk1VMWtTbVRqZVM1ZW14Ylo1dWY0b2RzTXhhV1NtUExtbDdJRzdnR0ZKWGllQW5URzN1OXVwRjVDaFZVT0VxcnhjeGhyQzQtMFFZQ2NjazRYVkxqNlVhOXZ6VGxvMHJGWnI3UVYzdUJYd2dTSjdaMmpTeXBkZ3BkNmVuZ25KWFQ5RV9yMm5RWndxVVN0RTV5c2pVNk9EZEh4QUdCb3JsRHpzRXlzblltZ1RzaDZ0YjZmOHd5RllpMUpFcjVsenpOWWdBTkFoTXFtaVR6T190UlRZeEh1RXFqck1jM0xPNzFvWlhkb29tOVVBaElFWl8wdXZIRGdtYVZhT1ZFTQ==","email":"marimuthuceo@gmail.com"},"registry.redhat.io":{"auth":"fHVoYy1wb29sLWVkZTA5ZjVjLTJmYTctNDFmMS04ZDRiLTg2MmVmMTY3ZjFlNjpleUpoYkdjaU9pSlNVelV4TWlKOS5leUp6ZFdJaU9pSmlPV0pqTlRjMU5UVXhOemcwTlRjNVltRmlNalpqWXpnd09XRTVPRE5pWXlKOS5CNWRsNGEzbFJzUlU4UDh5cjJkUFpuc05uM1NwQjRNM3BCZ0ZrdzItaHJvbW1MYkwtYzVuMlpRdmZsa05iNVhrQ2hjdlh0Z0h0MVhRUXpGQmFiOWROd252Rk9oR1NFZ1kyVjZzeHVvTkNKTUYwQXJjZTZuaVAzN3JXb09YXzJCRTIyUmQzUVJ6MjRTREo4bEhMLURMNlZZOWVQRVVMdVhIUFB5b0xRZEJyWHNwMF90UmJkQ1hNSWYzcDNVTTlWcFoxOUlVdk9TbmJjWmRIa2VMVG5aWjZHOGM5MHdsWkV6WDdZa1NFbUpRY09FR2I4YVA4MVVPejg0WHloc2tZSXFyWlRyLVhSSGQ5dUpUNFZlclc3QVhCTWRHMlFkcnBwS1c2MlM3cjR5NjJyWndvLXROUWRRWDNGRzg0RXhmUjRrYUp0LU42QmdoZ3NWUlBVdEtVb1NrdUhmQWw5QzlZQWsyZXJGaHU2RkhEZmhjN25zQzNRSy1ucHZJREJjbGRoR2paS2YyVGoxSTBIQTBmTzlvUlVZdEhXZ0c3MWEwb191WFc4UnRUTHBBWWpkc0lBTk1VMWtTbVRqZVM1ZW14Ylo1dWY0b2RzTXhhV1NtUExtbDdJRzdnR0ZKWGllQW5URzN1OXVwRjVDaFZVT0VxcnhjeGhyQzQtMFFZQ2NjazRYVkxqNlVhOXZ6VGxvMHJGWnI3UVYzdUJYd2dTSjdaMmpTeXBkZ3BkNmVuZ25KWFQ5RV9yMm5RWndxVVN0RTV5c2pVNk9EZEh4QUdCb3JsRHpzRXlzblltZ1RzaDZ0YjZmOHd5RllpMUpFcjVsenpOWWdBTkFoTXFtaVR6T190UlRZeEh1RXFqck1jM0xPNzFvWlhkb29tOVVBaElFWl8wdXZIRGdtYVZhT1ZFTQ==","email":"marimuthuceo@gmail.com"}}}'

OCP_VERSION="stable-4.15"
ARCH="x86_64"
OCP_RHCOS_VERSION="4.15"
OPENSHIFT_PACKAGES="https://mirror.openshift.com/pub/openshift-v4/${ARCH}"
OPENSHIFT_PACKAGES_CLIENT=${OPENSHIFT_PACKAGES}/clients/ocp/${OCP_VERSION}
OPENSHIFT_PACKAGES_RHCOS_DEPS=${OPENSHIFT_PACKAGES}/dependencies/rhcos/${OCP_RHCOS_VERSION}

NETWORK_PHYSICAL_INTERFACE_NAME="eno1"
NETWORK_VIRT_BRIDGE_INTERFACE_NAME="bridge0"
NETWORK_VIRT_BRIDGE_CONNECTION_IPV4_METHOD="manual"
NETWORK_VIRT_BRIDGE_CONNECTION_IPV4_ADDRESS="192.168.31.205/24"
NETWORK_VIRT_BRIDGE_NAME="br0"

# Folder setup
ocp_sno_setup_folders() {
    echo ""
    echo "Setting up folder structure..."
    mkdir -p {${OCP_SNO_SETUP_CLI_TOOLS},${OCP_SNO_SSHKEYS},${OCP_SNO_KVM_SETUP},${OCP_SNO_SECRETS},${OCP_SNO_INSTALLER_FILES}}
    echo ""
    echo "Folder structure created successfully."
}


# Generate SSH keys
generate_ssh_key() {
    echo ""
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -f ${OCP_SNO_SSHKEYS}/${OCP_CLUSTER_NAME} -N ""
    echo ""
    echo "SSH key generated successfully."
}

# Create OCP pull secret
create_pull_secret() {
    echo "Creating OCP pull secret..."
    cat <<EOF > ${OCP_SNO_SECRETS}/pull-secret.txt
${OCP_PULL_SECRET}
EOF
    echo "OCP pull secret created successfully."
}

# Configure storage
configure_storage() {
    echo "Configuring storage..."
    virsh pool-capabilities | grep "'dir' supported='yes'"
    virsh pool-define-as ${OCP_CLUSTER_NAME} dir --target "${TARGET_DISK_PARTITION}"
    virsh pool-build ${OCP_CLUSTER_NAME}
    virsh pool-start ${OCP_CLUSTER_NAME}
    virsh pool-autostart ${OCP_CLUSTER_NAME}
    virsh pool-info ${OCP_CLUSTER_NAME}
    virsh vol-create-as --pool ${OCP_CLUSTER_NAME} --name main --capacity 370 --format qcow2
    echo "Storage configured successfully."
}


configure_network() {
    echo "Configuring bridge network..."
    
    nmcli connection add type bridge con-name ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME} ifname ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME}
    
    nmcli con add type bridge-slave ifname ${NETWORK_PHYSICAL_INTERFACE_NAME} master ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME}
    
    nmcli con mod ${NETWORK_PHYSICAL_INTERFACE_NAME} master ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME}
    
    nmcli con mod ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME} ipv4.dns '208.67.222.222,208.67.220.220' ipv4.method ${NETWORK_VIRT_BRIDGE_CONNECTION_IPV4_METHOD} ipv4.addresses ${NETWORK_VIRT_BRIDGE_CONNECTION_IPV4_ADDRESS} ipv6.method "disabled" bridge.priority '16384' connection.autoconnect 1 connection.autoconnect-slaves 1 
    
    nmcli con up ${NETWORK_VIRT_BRIDGE_INTERFACE_NAME}
    
    echo "Network configured successfully."

    cat <<EOF > ${OCP_SNO_KVM_SETUP}/bridge0.xml
<network ipv6='no'>
    <name>$NETWORK_VIRT_BRIDGE_NAME</name>
    <forward mode="bridge"/>
    <bridge name="$NETWORK_VIRT_BRIDGE_INTERFACE_NAME"/>
</network>
EOF

    virsh net-define ${OCP_SNO_KVM_SETUP}/bridge0.xml
    virsh net-start ${NETWORK_VIRT_BRIDGE_NAME}
    virsh net-autostart ${NETWORK_VIRT_BRIDGE_NAME}
    echo "KVM network defined successfully."

}

# Download OCP tools and RHCOS
setup_ocp_tools() {
    echo "Downloading OCP client and OC Installer CLI..."

    curl -k ${OPENSHIFT_PACKAGES_CLIENT}/openshift-client-linux.tar.gz > oc.tar.gz
    tar zxf oc.tar.gz
    rm -rf README.md
    mv oc kubectl ${OCP_SNO_SETUP_CLI_TOOLS}
    rm -rf oc.tar.gz
    chmod +x ${OCP_SNO_SETUP_CLI_TOOLS}/oc

    curl -k ${OPENSHIFT_PACKAGES_CLIENT}/openshift-install-linux.tar.gz > openshift-install-linux.tar.gz
    tar zxvf openshift-install-linux.tar.gz
    rm -rf README.md
    mv openshift-install ${OCP_SNO_SETUP_CLI_TOOLS}
    rm -rf openshift-install-linux.tar.gz
    chmod +x ${OCP_SNO_SETUP_CLI_TOOLS}/openshift-install
}



ocp_sno_setup_folders
# generate_ssh_key
# create_pull_secret
setup_ocp_tools