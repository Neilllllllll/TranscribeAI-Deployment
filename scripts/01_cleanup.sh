#!/bin/bash 
source installation_script/config.sh

# Script pour nettoyer

function cleanup(){
    echo "Nettoyage des tentatives d'installation précédentes..."
    # Supprimer les containers Docker existants

    # Supprimer les images Docker existantes

    # Supprimer les volumes Docker existants

    # Supprimer les réseaux Docker existants

    # Supprimer les fichiers de configuration existants

    # Supprimer les dossier des repos existants
    remove_repositories
    echo "Fin du nettoyage. Prêt pour une nouvelle installation."
}

function remove_repositories(){
    for FOLDER in "${!REPO_URLS[@]}"; do
        if [ -d "$WORKING_DIR/${FOLDERS[$FOLDER]}" ]; then
            echo "Suppression du dossier $WORKING_DIR/${FOLDERS[$FOLDER]}..."
            rm -rf "$WORKING_DIR/${FOLDERS[$FOLDER]}"
        fi
    done
}