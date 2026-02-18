#!/bin/bash
# Vérifie que la machine est capable de déployer la stack.

# Etape 1 : Vérifier les prérequis 
function check_prerequisites() {
    display_header "Vérification des prérequis pour le déploiement de TranscribeAI"

    echo ""

    # Prérequis 1 : Docker d'installé
    log_info "Vérification de l'installation de Docker..."
    if command_exists docker; then
        log_success "Docker est installé."
    else
        log_error "Docker n'est pas installé. Veuillez installer Docker pour continuer. https://docs.docker.com/get-docker/"
        exit 1
    fi

    echo ""

    # Prérequis 2 : Docker Compose d'installé
    log_info "Vérification de l'installation de Docker Compose..."
    if command_exists docker compose &> /dev/null; then
        log_success "Docker Compose est installé."
    else
        log_error "Docker Compose n'est pas installé. Veuillez installer Docker Compose pour continuer. https://docs.docker.com/compose/install/"
        exit 1
    fi

    echo ""

    # Prérequis 3 : NVIDIA GPU disponible
    log_info "Vérification de l'accessibilité du GPU NVIDIA..."
    if command_exists nvidia-smi; then
        log_success "GPU NVIDIA est disponible."
    else
        log_error "NVIDIA GPU n'est pas disponible. Veuillez installer les pilotes NVIDIA pour continuer. https://www.nvidia.com/Download/index.aspx"
        exit 1
    fi

    echo ""

    # Prérequis 4 : Docker configuré pour utiliser les GPU NVIDIA
    log_info "Vérification du runtime docker pour avoir accès aux GPU NVIDIA..."
    if gpu_is_supported_in_docker; then
        log_success "Docker est configuré pour utiliser les GPU NVIDIA."
    else
        log_error "Docker ne semble pas être configuré pour utiliser les GPU NVIDIA. Veuillez configurer Docker pour utiliser les GPU. https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html"
        exit 1
    fi

    echo ""

    # Prérequis 5 : Ports 80 et 443 disponibles (non utilisés par d'autres services)
    log_info "Vérification de la disponibilité des ports 80 et 443..."
    if ports_is_available; then
        log_success "Les ports 80 et 443 sont disponibles."
    else
        log_error "Les ports 80 et/ou 443 sont déjà utilisés par un autre service. Veuillez libérer ces ports pour continuer."
        exit 1
    fi

    echo ""

    # Prérequis 6 : Certificats SSL dans le dossier volumes/certs/ (cert.crt et cert.pem) pour le reverse proxy (HTTPS)
    log_info "Vérification des certificats SSL..."

    if file_exists "$CERT_DIR/cert.crt";then
        log_success "Certificat cert.crt trouvé."
    else
        log_error "Certificat cert.crt non trouvé dans $CERT_DIR. Veuillez ajouter le certificat SSL pour continuer."
        exit 1
    fi

    if file_exists "$CERT_DIR/cert.pem";then
        log_success "Certificat cert.pem trouvé."
    else
        log_error "Certificat cert.pem non trouvé dans $CERT_DIR. Veuillez ajouter le certificat SSL pour continuer."
        exit 1
    fi

    echo ""

    # Prérequis 7 : Python 3.8+ installé pour les scripts de configuration
    log_info "Vérification de la version de Python..."
    if command_exists python3 && python_version_is_higher_than_3.8; then
        log_success "Python 3 est installé et compatible."
    else
        log_error "Python 3 n'est pas installé ou n'est pas compatible. Veuillez installer Python 3.8 ou une version supérieure pour continuer. https://www.python.org/downloads/"
        exit 1
    fi

    echo ""

    # Prérequis 8 : Création d'un environnement virtuel Python pour le script de configuration
    if virtual_env_correct; then
        log_success "Environnement virtuel Python déjà configuré."
    else
        log_info "Environnement virtuel Python mal configuré ou absent. Création en cours..."
        create_virtualenv
        log_success "Environnement virtuel Python créé."
    fi


    log_success "Fin de la vérification. Tous les prérequis sont satisfaits."
}

function gpu_is_supported_in_docker() {
    if docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi &> /dev/null
    then
        return 0
    else
        return 1
    fi
}

function ports_is_available() {
    for PORT in "${PORTS[@]}"; do
        if lsof -Pi :$PORT -sTCP:LISTEN -t &> /dev/null; then
            return 1
        fi
    done
    return 0
}

# Vérifie que Python 3.8+ est installé
function python_version_is_higher_than_3.8(){
    # Découpe le résultat de python3 --version pour extraire la version majeure et mineure
    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 8 ]; }; then
        log_error "Python 3.8 ou une version supérieure est requise. Version actuelle : $PYTHON_VERSION"
        return 1
    fi

    return 0
}

# Crée un environnement virtuel Python et installe la dépendance PyYAML
function create_virtualenv() {
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
        pip install PyYAML
        deactivate
    else
        rm -rf .venv
        create_virtualenv
    fi
}

# Vérifie si l'environnement virtuel est déjà configuré et contient la dépendance PyYAML
function virtual_env_correct(){
    if folder_exists ".venv" && [ "$(source .venv/bin/activate && pip list | grep PyYAML)" ]; then
        return 0
    else
        return 1
    fi
}