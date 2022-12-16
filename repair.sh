#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

repairPanel(){
    cd /var/www/pterodactyl

    php artisan down

    rm -r /var/www/pterodactyl/resources

    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache

    composer install --no-dev --optimize-autoloader

    php artisan view:clear

    php artisan config:clear

    php artisan migrate --seed --force

    chown -R www-data:www-data /var/www/pterodactyl/*

    php artisan queue:restart

    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

    apt update

    apt install -y nodejs

    npm i -g yarn

    yarn

    yarn build:production

    sudo php artisan optimize:clear

    php artisan up
}

while true; do
    read -p "Are you sure [y/N]? " yn
    case $yn in
        [Yy]* ) repairPanel; break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done