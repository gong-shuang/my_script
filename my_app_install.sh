#! /bin/sh
#
# Copyright (C) 2013 gongshuag Ltd. All rights reserved.
#
# 
#

check_for_package () 
{
    printf "Checking for $1... "
    if `dpkg -s $1 2> /dev/null | grep "Status: install ok installed" > /dev/null`; then
        printf "installed\n"
    else
        printf "not installed\n"
        install_package $1
    fi
}

install_package ()
{
    if $install; then
        printf "Installing $1... "
        if `apt-get -qq -y install $1 > /dev/null`; then
            printf "done\n"
            config=true
        fi
    fi
}

install=true

if [ $# -gt 0 ] ; then
    if [ $1 = "--no-install" ] ; then
        install=false
    else
        echo "Usage: ds-deps.sh [--no-install]"
        echo "Check for and install appliction program ."
        echo ""
        echo "  --no-install  Only check whether the program are installed, do not install"
        exit
    fi
fi

if [ `whoami` != root ] ; then
    echo "Error: Dependency management requires root privileges"
    exit 1
fi

config=false
check_for_package 'git'
if $config; then
    printf "Config git user name and email...\n"
    git config --global user.name baidng
    git config --global user.email baidng@163.com
fi

config=false
check_for_package 'vim' 
if $config; then
    printf "and install ctags cscope bundle...\n"
    install_package 'ctags'
    install_package 'cscope'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null
fi


printf "Checking for google-chrome-stable... "
if `dpkg -s google-chrome-stable 2> /dev/null | grep "Status: install ok installed" > /dev/null`; then
    printf "installed\n"
else
    printf "not installed\n"
    sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add
    sudo apt-get update
    install_package 'google-chrome-stable'
fi


printf "Checking for shadowsocks-qt5... "
if `dpkg -s shadowsocks-qt5 2> /dev/null | grep "Status: install ok installed" > /dev/null`; then
    printf "installed\n"
else
    printf "not installed\n"
    add-apt-repository ppa:hzwhuang/ss-qt5
    apt-get update
    check_for_package 'shadowsocks-qt5'
fi






