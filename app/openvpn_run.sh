#!/bin/bash

if [ -n "$USERNAME" -a -n "$PASSWORD" ]; then
	echo "$USERNAME" > /openvpn/auth.conf
	echo "$PASSWORD" >> /openvpn/auth.conf
	chmod 400 /openvpn/auth.conf
	set -- "$@" '--auth-user-pass' '/openvpn/auth.conf'
else
	echo "OpenVPN credentials not set. Exiting."
	exit 1
fi

openvpn --config "/openvpn/${PROTOCOL}-${ENCRYPTION}/${REGION}.ovpn" --auth-user-pass /openvpn/auth.conf --user nobody --auth-nocache --script-security 2

# echo "
# The OpenVPN connect command was issued.

# Confirming OpenVPN connection state... "

# # Check if manual PIA OpenVPN connection is initialized.
# # Manually adjust the connection_wait_time if needed
# connection_wait_time=10
# confirmation="Initialization Sequence Complete"
# for (( timeout=0; timeout <=$connection_wait_time; timeout++ ))
# do
#   sleep 1
#   if grep -q "$confirmation" /var/log/pia_debug.log; then
#     connected=true
#     break
#   fi
# done

# ovpn_pid="$(cat /run/pia.pid)"

# # Report and exit if connection was not initialized within 10 seconds.
# if [ "$connected" != true ]; then
#   echo "The VPN connection was not established within 10 seconds."
#   kill $ovpn_pid
#   exit 1
# fi

# echo "Initialization Sequence Complete!

# At this point, internet should work via VPN.
# "

# echo "OpenVPN Process ID: $ovpn_pid

# To disconnect the VPN, run:

# --> sudo kill $ovpn_pid <--
# "
