# AutoSSH_to_VPS

# About

This is a script to help set up a reverse ssh connection to a vps</br>
After running the autossh script you will need to ssh into your server with the key.</br>

to do that you will need to copy the ssh key to the server</br>
in order to do that we will run a simple but easy to forget command</br>

`ssh-copy-id -i ~/.ssh/<ssh key> <user>@<server ip>`</br>
the `-i` is to use the select the key</br>
make sure you do a **direct path** to where the key is located</br>
when using ssh remember that you need to identify the user you're signing into the computer with will be a **user account** on the far end.</br>
