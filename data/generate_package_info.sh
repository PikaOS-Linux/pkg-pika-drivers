#! /bin/bash

if [[ $1 == "version" ]]
then
	if [[ $2 == "pika-rocm-meta" ]]
	then
		echo "Version: $(apt-cache show rocm-core | grep Version: | cut -d":" -f2 | head -n1)"
	else
		echo "Version: $(apt-cache show $2 | grep Version: | cut -d":" -f2 | head -n1)"
	fi
elif [[ $1 == "description" ]]
then
	if echo "$2" | grep mesa-git &> /dev/null
	then
		printf "WARNING: THIS DRIVER IS EXPERMINTAL USE AT YOUR OWN RISK!\n$(apt-cache show mesa-git | grep 'Description*' | cut -d":" -f2 | head -n1)"
	else
		apt-cache show $2 | grep 'Description*' | cut -d":" -f2 | head -n1
	fi
elif [[ $1 == "device" ]]
then
	if echo "$2" | grep -i -E 'pika-rocm-meta|vulkan-amdgpu-pro|amf-amdgpu-pro|amdvlk|opencl-legacy-amdgpu-pro-icd|amdgpu-pro-oglp' &> /dev/null
	then
		DEVICE="$(lspci | grep -i -E 'vga|display|3d' | grep -i AMD)"
	elif echo "$2" | grep -i -E 'xone' &> /dev/null
	then
		DEVICE="$(lsusb | grep -i xbox)"
	elif echo "$2" | grep -i -E 'intel' &> /dev/null
	then
		DEVICE="$(lspci | grep -i -E 'vga|display|3d' | grep -i intel)"
	elif echo "$2" | grep -i -E 'nvidia' &> /dev/null
	then
		DEVICE="$(lspci | grep -i -E 'vga|display|3d' | grep -i nvidia)"
	elif echo "$2" | grep -i -E 'mesa' &> /dev/null
	then
		DEVICE="$(lspci | grep -i -E 'vga|display|3d' | grep -vi nvidia)"
	fi
	if [[ ! -z $DEVICE ]]
	then
		echo "Device: $DEVICE"
	else
		echo "Device: UNKNOWN!"
	fi
fi