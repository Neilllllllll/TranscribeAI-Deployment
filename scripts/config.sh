#!/usr/bin/env bash

# Variable de configuration pour le déploiement de TranscribeAI

WORKING_DIR="${WORKING_DIR:-$(pwd)}"

REPO_BASE_URL="https://github.com/Neilllllllll/"

# Liste des dépôts nécessaires
declare -A REPO_URLS=(
  [Frontend]="${REPO_BASE_URL}TranscribeAI-Frontend.git"
  [Backend]="${REPO_BASE_URL}TranscribeAI-Backend.git"
  [ReverseProxy]="${REPO_BASE_URL}TranscribeAI-ReverseProxy.git"
  [STT]="${REPO_BASE_URL}TranscribeAI-STT.git"
)

# Noms des dossiers cibles pour chaque dépôt
declare -A FOLDERS=(
  [Frontend]="TranscribeAI-Frontend"
  [Backend]="TranscribeAI-Backend"
  [ReverseProxy]="TranscribeAI-ReverseProxy"
  [STT]="TranscribeAI-STT"
)