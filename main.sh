#!/usr/bin/env bash
# ============================================================
# LTactic - Framework militaire OSINT & BlueTeam pour Termux
# Auteur : Teremu
# Version : 1.3 ULTIMATE (TUI + Auto-Update + Debug + Infiltration)
# ============================================================

# --- Chargement des couleurs ---
source Core/colors.sh

# --- Bannière militaire ---
source Core/banner.sh

# --- Menu principal (TUI) ---
source Core/menu.sh

# ============================================================
# CONFIGURATION GLOBALE
# ============================================================

LT_VERSION="1.3-ULTIMATE"
LT_HOME="$HOME/LTactic"
LOG_FILE="$LT_HOME/logs/ltactic.log"

DEBUG=false
INFILTRATION=false

# ============================================================
# LOGGING MILITAIRE
# ============================================================

log() {
    mkdir -p "$LT_HOME/logs"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

debug() {
    if $DEBUG; then
        echo -e "${YELLOW}[DEBUG]${NC} $1"
        log "[DEBUG] $1"
    fi
}

# ============================================================
# MODE INFILTRATION (Silencieux)
# ============================================================

infiltration_mode() {
    INFILTRATION=true
    DEBUG=false
    clear
    echo -e "${GREEN}[✔] Mode infiltration activé — silence radio.${NC}"
    log "Mode infiltration activé"
}

# ============================================================
# AUTO-UPDATE GITHUB
# ============================================================

auto_update() {
    echo -e "${CYAN}[↻] Vérification des mises à jour LTactic...${NC}"
    log "Vérification des mises à jour"

    git fetch origin main &>/dev/null

    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)

    if [[ "$LOCAL" != "$REMOTE" ]]; then
        echo -e "${GREEN}[✔] Mise à jour disponible — téléchargement...${NC}"
        log "Mise à jour détectée"
        git pull origin main
        echo -e "${GREEN}[✔] LTactic mis à jour avec succès.${NC}"
        log "Mise à jour effectuée"
    else
        echo -e "${BLUE}[i] LTactic est déjà à jour.${NC}"
        log "Aucune mise à jour"
    fi
}

# ============================================================
# VÉRIFICATIONS SYSTÈME
# ============================================================

check_environment() {
    echo -e "${YELLOW}[⚠] Vérification de l'environnement...${NC}"
    log "Vérification de l'environnement"

    # Termux
    if [[ -z "$PREFIX" ]]; then
        echo -e "${RED}[ERREUR] LTactic doit être exécuté dans Termux.${NC}"
        log "Erreur : environnement non-Termux"
        exit 1
    fi

    # Bash
    if [[ -z "$BASH_VERSION" ]]; then
        echo -e "${RED}[ERREUR] Bash est requis.${NC}"
        log "Erreur : Bash manquant"
        exit 1
    fi

    # Android version
    ANDROID_VERSION=$(getprop ro.build.version.release)
    echo -e "${GREEN}[OK] Android détecté : $ANDROID_VERSION${NC}"
    log "Android version : $ANDROID_VERSION"
}

# ============================================================
# INITIALISATION DES DOSSIERS
# ============================================================

init_directories() {
    echo -e "${YELLOW}[⚙] Initialisation des modules...${NC}"
    log "Initialisation des dossiers"

    for dir in Core Modules Plugins Docs; do
        if [[ ! -d "$dir" ]]; then
            echo -e "${RED}[!] Dossier manquant : $dir${NC}"
            echo -e "${BLUE}→ Création automatique...${NC}"
            mkdir -p "$dir"
            log "Création du dossier : $dir"
        fi
    done

    mkdir -p "$LT_HOME/logs"
    echo -e "${GREEN}[OK] Structure vérifiée.${NC}"
}

# ============================================================
# MODULES DYNAMIQUES (Auto-détection)
# ============================================================

load_modules() {
    echo -e "${YELLOW}[📦] Chargement des modules LTactic...${NC}"
    log "Chargement des modules"

    MODULE_LIST=$(find Modules -type f -name "*.sh")

    for module in $MODULE_LIST; do
        echo -e "${GREEN}[OK] Module détecté : $module${NC}"
        log "Module détecté : $module"
    done
}

# ============================================================
# PLUGINS DYNAMIQUES
# ============================================================

load_plugins() {
    echo -e "${YELLOW}[🔌] Chargement des plugins...${NC}"
    log "Chargement des plugins"

    if [[ -f Plugins/plugin-manager.sh ]]; then
        source Plugins/plugin-manager.sh
        echo -e "${GREEN}[OK] Plugin Manager chargé.${NC}"
        log "Plugin Manager chargé"
    else
        echo -e "${RED}[ERREUR] plugin-manager.sh introuvable.${NC}"
        log "Erreur : plugin-manager.sh introuvable"
    fi
}

# ============================================================
# MENU TUI MILITAIRE
# ============================================================

start_menu() {
    echo -e "${CYAN}[🎖️] Démarrage du menu militaire LTactic...${NC}"
    log "Démarrage du menu"
    sleep 0.5
    menu_main
}

# ============================================================
# PROGRAMME PRINCIPAL
# ============================================================

main() {
    clear
    banner

    log "LTactic démarré — Version $LT_VERSION"

    check_environment
    init_directories
    auto_update
    load_modules
    load_plugins

    start_menu
}

# ============================================================
# OPTIONS LANCEMENT
# ============================================================

case "$1" in
    --debug)
        DEBUG=true
        echo -e "${YELLOW}[DEBUG] Mode debug activé.${NC}"
        log "Mode debug activé"
        main
        ;;
    --infiltration)
        infiltration_mode
        main
        ;;
    *)
        main
        ;;
esac
