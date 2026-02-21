# Lance la stack Docker avec docker compose
function deploy() {
    log_info "Déploiement de l'application TranscribeAI..."
    docker compose \
    -f $COMPOSE_FILE \
    --env-file $ENV_FILE \
    -p $PROJECT_NAME \
    up -d
}