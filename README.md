# TranscribeAI Suite

TranscribeAI vise à fournir une suite d’outils permettant la conversion rapide et fiable de contenus audio en texte, adaptée aussi bien aux usages professionnels qu’aux besoins individuels.

## Sommaire

- [Présentation de TranscribeAI](#présentation-de-transcribeai)
    - [Fonctionnalités et modules](#fonctionnalités-et-modules)
    - [Architecture de l'app](#architecture-de-lapp)
    - [Mutualisation des projets](#mutualisation-des-projets)

## Présentation de TranscribeAI

### Fonctionnalités et modules

TranscribeAI est un outil de retranscription vocale divisé en trois modules répondant à des cas d'usage distincts :

- <strong> 1. Transcription Mono-voix </strong>

Ce mode est optimisé pour le traitement de fichiers audio volumineux nécessitant une transcription brute mono-voix.

* Fonctionnalités clés : 

    - Téléversement et transcription d'un fichier audio à taille variable
    - Correction globale : Remplacement automatique de toutes les occurrences spécifiques mal retranscrites sur l'ensemble du texte. 
    - Synchronisation : Synchronisation du curseur de lecture bidirectionnelle «Audio to Text» et «Text to Audio».
    - Export multi-format : PDF, TXT, DOCX ou copie directe dans le presse-papier.
    - Barre d'alerte :
        - Position dans la file d'attente.
        - État de la tâche de transcription : PENDING, PROCESSING, FAILED ou COMPLETED
    - Validation de conformité du fichier (format et taille). 

> ⚠️ **Important**
> Ce mode n’est pas destiné à la micro-édition du texte.

- <strong> 2. Transcription réunions </strong>

Conçu pour la retranscription de conférences et réunions, permettant de séparer les différents intervenants ( locuteurs ).

* Fonctionnalités clés : 

    - Téléversement et diarisation d'un fichier audio à taille variable
    - Gestion des locuteurs 
        - Définition optionnelle du nombre minimum et maximum de participants.
        - Personnalisation visuelle (nom et couleur) pour chaque locuteur identifié.
    - Correction globale : Remplacement automatique de toutes les occurrences spécifiques mal retranscrites sur l'ensemble du texte. 
    - Synchronisation : Synchronisation du curseur de lecture bidirectionnelle «Audio to Text» et «Text to Audio».
    - Export multi-format : PDF, TXT, DOCX ou copie directe dans le presse-papier.
    - Barre d'alerte :
        - Position dans la file d'attente.
        - État du job : PENDING, PROCESSING, FAILED ou COMPLETED
    - Validation de conformité du fichier (format et taille).

> ⚠️ **Important**
> Ce mode n’est pas destiné à la micro-édition du texte.

- <strong> 3. Dictée vocale </strong> 

En cours de développement

### Architecture de l'app

L’architecture repose sur une approche orientée micro-services, favorisant la modularité, la scalabilité et l’isolation des composants.

![Logo](./doc/assets/Schéma-docker-stack.png)

- Composition de la Stack Docker
    - **Reverse Proxy** : Point d'entrée unique gérant le protocole HTTPS et le routage des requêtes.
    - **Frontend** : Interface utilisateur permettant de communiquer avec le Backend
    - **API REST** : Expose les endpoints, place les jobs ( tâches ) en file d'attente et récupère les résultats en base de données.
    - **Redis** : Broker de messages gérant deux files d’attente distinctes (mono-voix et diarisation)
    - **BDD** : Stockage des tâches de transcription/diarisation, de leurs états d’avancement et des résultats finaux. (Les données ne sont pas persistées.)
    - **Worker** : Agent surveillant les tâches en file d'attente et sollicitant les services dédiés.
    - **Mono-voix STT** : Chargé de retranscrire des fichiers audios
    - **Multi-voix STT** : Chargé de retranscrire et de diarizer des fichiers audios

### Mutualisation des projets

Chaque module de la stack possède son propre dépôt GitHub et son image Docker Hub.

| Nom du module | Dépôt GitHub | Image Docker Hub |
|--------------|-------------|------------|
| Reverse Proxy | [GitHub](https://github.com/Neilllllllll/TranscribeAI-ReverseProxy.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-reverse-proxy) |
| Frontend | [GitHub](https://github.com/Neilllllllll/TranscribeAI-Frontend.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-frontend) |
| Backend| [GitHub](https://github.com/Neilllllllll/TranscribeAI-Backend.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-api) |
| Worker diarisation | [GitHub](https://github.com/Neilllllllll/TranscribeAI-Backend.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-multi-voice-worker) |
| Worker Mono-voix | [GitHub](https://github.com/Neilllllllll/TranscribeAI-Backend.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-mono-voice-worker) |
| Mono-voix STT | [GitHub](https://github.com/Neilllllllll/TranscribeAI-Mono-voix-stt.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-mono-voice-stt) |
| Multi-voix STT | [GitHub](https://github.com/Neilllllllll/TranscribeAI-Multi-voix-STT.git) | [Docker Hub](https://hub.docker.com/r/noeuil/transcribe-ai-multi-voice-stt) |

