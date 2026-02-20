# Fournir des logs uniformes 

function log_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

function log_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

function log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}