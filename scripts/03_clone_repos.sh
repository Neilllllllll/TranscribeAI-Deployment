#!/bin/bash
source ../config.sh

# Fonction pour cloner les dépôts nécessaires
function get_repositories() {
    echo "Clonage des dépôts nécessaires..."
    for SERVICE in "${!REPO_URLS[@]}"; do
        echo "Clonage du dépôt $SERVICE"
        clone_repository "${REPO_URLS[$SERVICE]}" "${FOLDERS[$SERVICE]}"
        echo "Clonage du dépôt $SERVICE fait"
    done
    echo "Tous les dépôts ont été clonés avec succès."
}

# Fonction pour cloner un dépôt Git dans un dossier spécifique
function clone_repository() {
    local repo_url=$1
    local target_dir=$2

    if [ -d "$WORKING_DIR/$target_dir" ]; then
        echo "Le dossier $WORKING_DIR/$target_dir existe déjà. Suppression avant de cloner."
        rm -rf "$WORKING_DIR/$target_dir"
    fi

    echo "Clonage du dépôt $repo_url dans $WORKING_DIR/$target_dir..."
    git clone "$repo_url" "$WORKING_DIR/$target_dir"
}