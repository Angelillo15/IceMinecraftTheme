if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

fix() {
    echo "Fixing theme..."
    cd /var/www/pterodactyl
    npx update-browserslist-db@latest
    echo "Please wait until the process is finished..."
    yarn build:production
}


echo "Welcome to the IceMinecraftTheme fixer!"
echo "This script will fix the theme if you have an problem with it."
echo "If you have any problem with the theme, please contact me on Discord: https://discord.nookure.com/"

while true; do
    read -p "Are you sure [y/N]? " yn
    case $yn in
        [Yy]* ) fix; break;;
        [Nn]* ) exit;;
        * ) exit;;
    esac
done