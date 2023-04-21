#!/bin/bash

BLUE='\033[0;34m'.
NO_COLOR='\033[0m'

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf IceMinecraftTheme.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r IceMinecraftTheme
    git clone https://github.com/Angelillo15/IceMinecraftTheme.git
    cd IceMinecraftTheme
    rm /var/www/pterodactyl/resources/scripts/IceMinecraftTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    rm /var/www/pterodactyl/resources/scripts/components/server/console/Console.tsx
    mv resources/scripts/index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv resources/scripts/IceMinecraftTheme.css /var/www/pterodactyl/resources/scripts/IceMinecraftTheme.css
    mv resources/scripts/components/server/console/Console.tsx /var/www/pterodactyl/resources/scripts/components/server/console/Console.tsx
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn
    export NODE_OPTIONS=--openssl-legacy-provider
    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are you sure that you want to install the theme [y/N]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) exit;;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/Angelillo15/IceMinecraftTheme/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf IceMinecraftTheme.tar.gz
    rm IceMinecraftTheme.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
                                                                                                                           
printf "${blue} ____       _____        ______          _________________  ____   ____      ______        ______  _______        ______    \n"
printf "${blue}|    |  ___|\    \   ___|\     \        /                 \|    | |    | ___|\     \      |      \/       \   ___|\     \   \n"
printf "${blue}|    | /    /\    \ |     \     \       \______     ______/|    | |    ||     \     \    /          /\     \ |     \     \  \n"
printf "${blue}|    ||    |  |    ||     ,_____/|         \( /    /  )/   |    |_|    ||     ,_____/|  /     /\   / /\     ||     ,_____/| \n"
printf "${blue}|    ||    |  |____||     \--'\_|/          ' |   |   '    |    .-.    ||     \--'\_|/ /     /\ \_/ / /    /||     \--'\_|/ \n"
printf "${blue}|    ||    |   ____ |     /___/|              |   |        |    | |    ||     /___/|  |     |  \|_|/ /    / ||     /___/|   \n"
printf "${blue}|    ||    |  |    ||     \____|\            /   //        |    | |    ||     \____|\ |     |       |    |  ||     \____|\  \n"
printf "${blue}|____||\ ___\/    /||____ '     /|          /___//         |____| |____||____ '     /||\____\       |____|  /|____ '     /| \n"
printf "${blue}|    || |   /____/ ||    /_____/ |         |    |          |    | |    ||    /_____/ || |    |      |    | / |    /_____/ | \n"
printf "${blue}|____| \|___|    | /|____|     | /         |____|          |____| |____||____|     | / \|____|      |____|/  |____|     | / \n"
printf "${blue}  \(     \( |____|/   \( |_____|/            \(              \(     )/    \( |_____|/     \(          )/       \( |_____|/  \n"
printf "${blue}   '      '   )/       '    )/                '               '     '      '    )/         '          '         '    )/     \n"
printf "${blue}              '             '                                                   '                                    '      \n"
echo ""
echo "Copyright (c) 2022 Angelillo15 | angelillo15.es"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "Discord: https://discord.angelillo15.es/"
echo "Website: https://angelillo15.es/"
echo ""
echo "[1] Install theme"
echo "[2] Restore backup"
echo "[3] Repair panel (use if you have an error in the theme installation)"
echo "[4] Update the panel"
echo "[5] Exit"
printf "${NO_COLOR}"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    repair
fi
if [ $choice == "5" ]
    then
    exit
fi
