
# CENTOS7 SETUP - run as ROOT.
# Home directory is /root

# YUM updates
yum update
yum update coreutils
yum install gcc openssl-devel bzip2-devel
yum groupinstall -y "Development Tools"
yum update git

# remove password complexity at /etc/pam.d/system-auth
# remove all instances of 'use_authtok'
# comment line with 'cracklib.so'

# disable beeping from input and in vi/m
echo 'set bell-style none' >> ~/.inputrc
echo 'set noeb vb t_vb=' >> ~/.vimrc
echo 'set nu' >> ~/.vimrc
echo 'au GUIEnter * set vb t_vb=' >> ~/.vimrc

# install python3.6
yum install python36u
yum install python36u-pip
python3.6 -m pip install numpy
python3.6 -m pip install pandas
python3.6 -m pip install seaborn

# create user CODE
adduser code

# add CODE to wheel group for SUDO rights
usermod -a -G wheel code

