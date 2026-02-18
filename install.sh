#!/bin/bash
source installation_script/prerequisites/check_software_prerequisites.sh
source installation_script/cleanup/clean_up.sh
source installation_script/get_repositories/get_repositories.sh
source installation_script/setup/setup_configuration.sh

# Etape 0 : Charger la configuration
setup_configuration
echo $WORKING_DIR
# Etape 1 : Tout nettoyer avant de commencer 
# cleanup
# Etape 2 : Vérifier les prérequis 
# check_prerequisites
# Etape 3 : Cloner les dépôts nécessaires
# get_repositories
# Etape 4 : Configurer le docker-compose.yml
# Etape 5 : Lancer la stack avec docker-compose