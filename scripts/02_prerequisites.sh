#!/bin/bash

# Etape 1 : Vérifier les prérequis 
function check_prerequisites() {
    echo "Vérification des prérequis logiciels..."
    # Prérequis 1 : Docker
    check_docker_is_installed
    # Prérequis 2 : Vérifier que Docker Compose est installé
    check_docker_compose_is_installed
    # Prérequis 3 : Vérifier que NVIDIA GPU est disponible
    check_nvidia_gpu_is_available
    # Prérequis 4 : Vérifier que Docker est configuré pour utiliser les GPU NVIDIA
    check_gpu_support_in_docker
    echo "Fin de la vérification. Tous les prérequis logiciels sont satisfaits."
}

function check_docker_is_installed() {
    if ! command -v docker &> /dev/null
    then
        echo "Docker n'est pas installé. Veuillez installer Docker pour continuer. https://docs.docker.com/get-docker/"
        exit
    fi
}

function check_docker_compose_is_installed() {
    if ! command -v docker compose &> /dev/null
    then
        echo "Docker Compose n'est pas installé. Veuillez installer Docker Compose pour continuer. https://docs.docker.com/compose/install/"
        exit
    fi
}

function check_nvidia_gpu_is_available() {
    if ! command -v nvidia-smi &> /dev/null
    then
        echo "NVIDIA GPU n'est pas disponible. Veuillez installer les pilotes NVIDIA pour continuer. https://www.nvidia.com/Download/index.aspx"
        exit
    fi
}

function check_gpu_support_in_docker() {
    if ! sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi &> /dev/null
    then
        echo "Docker ne semble pas être configuré pour utiliser les GPU NVIDIA. Veuillez configurer Docker pour utiliser les GPU. https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html"
        exit
    fi
}