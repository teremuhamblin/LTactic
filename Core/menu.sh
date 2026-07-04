#!/usr/bin/env bash

# ============================================================
# MENU MILITAIRE LTactic — TUI ULTIMATE
# ============================================================

source Core/colors.sh

menu_main() {
    while true; do
        clear

        echo -e "${GREEN}"
        echo "==============================================="
        echo "        LTactic — Menu Militaire ULTIMATE"
        echo "==============================================="
        echo -e "${NC}"

        echo -e "${CYAN}Version : ${NC}$LT_VERSION"
        echo ""

        echo -e "${YELLOW}1) Modules dynamiques${NC}"
        echo -e "${YELLOW}2) Plugins${NC}"
        echo -e "${YELLOW}3) Logs militaires${NC}"
        echo -e "${YELLOW}4) Auto-update GitHub${NC}"
        echo -e "${YELLOW}5) Mode Debug${NC}"
        echo -e "${YELLOW}6) Mode Infiltration${NC}"
        echo -e "${YELLOW}7) Quitter${NC}"

        echo ""
        read -rp "Choix : " CHOICE

        case "$CHOICE" in

            1)
                menu_modules
                ;;

            2)
                menu_plugins
                ;;

            3)
                menu_logs
                ;;

            4)
                auto_update
                read -rp "Appuyer sur Entrée pour continuer..."
                ;;

            5)
                DEBUG=true
                echo -e "${GREEN}[✔] Mode debug activé.${NC}"
                log "Mode debug activé via menu"
                sleep 1
                ;;

            6)
                infiltration_mode
                sleep 1
                ;;

            7)
                echo -e "${RED}[✖] Fermeture LTactic...${NC}"
                log "Fermeture LTactic"
                exit 0
                ;;

            *)
                echo -e "${RED}[!] Choix invalide.${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================================
# MODULES DYNAMIQUES
# ============================================================

menu_modules() {
    clear
    echo -e "${CYAN}=== Modules dynamiques détectés ===${NC}"

    MODULE_LIST=$(find Modules -type f -name "*.sh")

    i=1
    declare -A MODULE_MAP

    for module in $MODULE_LIST; do
        echo -e "${GREEN}$i) $module${NC}"
        MODULE_MAP[$i]=$module
        ((i++))
    done

    echo ""
    read -rp "Sélectionner un module : " M

    if [[ -n "${MODULE_MAP[$M]}" ]]; then
        log "Exécution module : ${MODULE_MAP[$M]}"
        bash "${MODULE_MAP[$M]}"
    else
        echo -e "${RED}[!] Module invalide.${NC}"
        sleep 1
    fi
}

# ============================================================
# PLUGINS
# ============================================================

menu_plugins() {
    clear
    echo -e "${CYAN}=== Gestion des plugins ===${NC}"

    if declare -f plugin_menu >/dev/null; then
        plugin_menu
    else
        echo -e "${RED}[!] plugin_menu non trouvé dans plugin-manager.sh${NC}"
        sleep 1
    fi
}

# ============================================================
# LOGS MILITAIRES
# ============================================================

menu_logs() {
    clear
    echo -e "${CYAN}=== Logs militaires LTactic ===${NC}"

    if [[ -f "$LOG_FILE" ]]; then
        echo -e "${GREEN}Affichage des logs :${NC}"
        echo ""
        cat "$LOG_FILE"
    else
        echo -e "${RED}[!] Aucun log trouvé.${NC}"
    fi

    echo ""
    read -rp "Appuyer sur Entrée pour continuer..."
}
