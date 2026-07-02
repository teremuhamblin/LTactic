source Core/colors.sh
source Core/banner.sh

menu() {
    clear
    banner
    echo -e "${GREEN}1) Reconnaissance LAN${RESET}"
    echo -e "${GREEN}2) Informations système${RESET}"
    echo -e "${GREEN}3) Plugins${RESET}"
    echo -e "${RED}0) Quitter${RESET}"
    read -p "Choix : " CH
    case $CH in
        1) bash Modules/lan/recon.sh ;;
        2) bash Modules/system/sysinfo.sh ;;
        3) bash Plugins/plugin-manager.sh ;;
        0) exit ;;
    esac
}
menu
