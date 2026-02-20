#!/bin/bash
# Script principal pour déployer la stack TranscribeAI
source scripts/bash_lib/utils.sh
source scripts/bash_lib/log.sh

source scripts/config.sh
source scripts/01_cleanup.sh
source scripts/02_prerequisites.sh
source scripts/04_deploy.sh
source scripts/05_verify.sh

# Etape 1 : Tout nettoyer avant de commencer 
cleanup

# Etape 2 : Vérifier les prérequis 
check_prerequisites

# Etape 3 : Configurer le fichier d'environnement via un script Python interactif
display_header "Configuration des variables d'environnement"

echo ""

source ./.venv/bin/activate
python3 scripts/03_configure_env.py
status=$? # Récupère le code de retour du script Python

if [ $status -eq 0 ]; then
    log_success "Configuration des variables d'environnement terminée avec succès."
else
    log_error "Erreur pendant la configuration des variables d'environnement, le script d'installation s'est arrêté."
    deactivate
    exit 1
fi
deactivate

# Etape 4 : Lancer la stack avec docker-compose
deploy

# Etape 5 : Vérifier que les services sont opérationnels
time=60
log_info "Attente de $time secondes pour laisser le temps à Docker de démarrer les conteneurs..."
for i in $(seq 1 $time); do
    echo -ne "Attente... $i/$time\r"
    sleep 1
done

verify_deployment