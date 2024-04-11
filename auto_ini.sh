#!/bin/bash

# How to use?: 
# 	chmod +x auto_ini.sh
# 	sudo ./auto_ini.sh

# This script is for Ubuntu 22.04
# If you execute in Hyper-V:
	# Run in your local Machine the follow command: 
	# 	Set-VM -VMName <your_vm_name>  -EnhancedSessionTransportType HvSocket

# Function to check if it is running in a virtual machine
check_virtualmachine() {
    local product_name=$(sudo dmidecode -s system-product-name)
    if [[ "$product_name" =~ "Virtual Machine" ]]; then
        echo 0  # Hyper-V
    elif [[ "$product_name" =~ "VMware|VirtualBox|QEMU|Xen|KVM" ]]; then
        echo 1  # Other virtual machines (VirtualBox, VMware, QEMU, Xen, KVM)
    elif [[ "$product_name" =~ "VMware" ]]; then
        echo 2  # VMware specifically
    else
        echo 3  # No virtual machine detected
    fi
}

# Check if it is running in a virtual machine
check_virtual_result=$(check_virtualmachine)

# Function to display error messages and exit the script
exit_with_error() {
    echo "Error: $1"
    exit 1
}

# Update repositories
sudo apt update || exit_with_error "Error updating repositories."

# Update the system
sudo apt upgrade -y || exit_with_error "Error updating system."

# Update Ubuntu drivers
sudo ubuntu-drivers autoinstall || exit_with_error "Error updating drivers."

# Check if it is running in a virtual machine
if [ "$check_virtual_result" -ne 3 ]; then
    wget https://raw.githubusercontent.com/Hinara/linux-vm-tools/ubuntu20-04/ubuntu/22.04/install.sh || exit_with_error "Error getting installer."
    sudo chmod +x install.sh
    sudo ./install.sh || exit_with_error "Error updating system."
fi

# Notify the user that the update is complete
echo "Update completed."

# End of Program
echo "Press Enter to continue..."
read
