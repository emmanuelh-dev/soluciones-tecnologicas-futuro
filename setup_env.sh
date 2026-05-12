#!/bin/bash
# setup_env.sh - Automatización interactiva de entorno para Fintech App
# Este script configura el entorno DevOps con confirmación en cada paso

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
DRY_RUN=false
PROCEED=false

# Función para mostrar encabezado
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

# Función para mostrar advertencia
print_warning() {
    echo -e "${YELLOW}⚠️  ADVERTENCIA: $1${NC}\n"
}

# Función para mostrar info
print_info() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Función para mostrar error
print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
}

# Función de confirmación
confirm() {
    local prompt="$1"
    local response
    
    while true; do
        echo -e -n "${YELLOW}$prompt (s/n): ${NC}"
        read -r response
        case "$response" in
            [Ss]|[Ss][Ii])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo "Por favor, responde con 's' o 'n'."
                ;;
        esac
    done
}

# Menú principal
show_menu() {
    print_header "CONFIGURADOR DE ENTORNO DEVOPS - SOLUCIONES TECNOLÓGICAS DEL FUTURO"
    
    echo "Este script realizará las siguientes acciones:"
    echo "  1. Actualizar paquetes del sistema"
    echo "  2. Instalar Docker, Python3-pip y Git"
    echo "  3. Configurar el servicio Docker"
    echo "  4. Añadir usuario actual al grupo 'docker'"
    echo "  5. Crear tarea cron para limpieza de logs"
    echo ""
    
    echo -e "${YELLOW}CONSIDERACIONES IMPORTANTES:${NC}"
    echo "  • Este script requiere permisos de 'sudo'"
    echo "  • Realizará cambios en paquetes y servicios del sistema"
    echo "  • La adición al grupo 'docker' requiere reiniciar la sesión"
    echo "  • La tarea cron se ejecutará diariamente a las 00:00"
    echo ""
    
    if confirm "¿Deseas continuar con la configuración?"; then
        if confirm "¿Usar modo DRY-RUN (simular sin ejecutar)?"; then
            DRY_RUN=true
            print_info "Modo DRY-RUN activado - solo se mostrarán los comandos"
        else
            print_warning "Se ejecutarán cambios reales en el sistema"
            if confirm "¿Estás seguro de que deseas continuar?"; then
                PROCEED=true
            fi
        fi
    else
        print_error "Configuración cancelada por el usuario"
        exit 0
    fi
}

# Ejecutar comando con validación
run_command() {
    local description="$1"
    local command="$2"
    
    echo -e "${BLUE}→ $description${NC}"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}[DRY-RUN]${NC} $command"
    elif [ "$PROCEED" = true ]; then
        if eval "$command"; then
            print_info "$description completado"
        else
            print_error "$description falló"
            return 1
        fi
    fi
}

# PASO 1: Actualizar paquetes
step_update_packages() {
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        run_command "Actualizar lista de paquetes" "sudo apt update -y"
        run_command "Instalar upgrades disponibles" "sudo apt upgrade -y"
    fi
}

# PASO 2: Instalar dependencias
step_install_dependencies() {
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        run_command "Instalar Docker, Python3-pip y Git" "sudo apt install -y docker.io python3-pip git"
    fi
}

# PASO 3: Configurar Docker
step_configure_docker() {
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        run_command "Habilitar y arrancar servicio Docker" "sudo systemctl enable --now docker"
    fi
}

# PASO 4: Añadir usuario al grupo docker
step_add_user_to_docker() {
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        local user=$(whoami)
        local cmd="sudo usermod -aG docker $user"
        
        run_command "Añadir usuario '$user' al grupo 'docker'" "$cmd"
        
        if [ "$PROCEED" = true ]; then
            print_warning "Deberás reiniciar la sesión para que los cambios de grupo surtan efecto"
            echo "Ejecuta: newgrp docker"
        fi
    fi
}

# PASO 5: Crear tarea cron
step_setup_cron() {
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        local cron_job="0 0 * * * /usr/bin/find /var/log -type f -name '*.log' -exec truncate -s 0 {} +"
        local cmd="(sudo crontab -l 2>/dev/null | grep -Fv '/var/log'; echo '$cron_job') | sudo crontab -"
        
        run_command "Configurar limpieza automática de logs (00:00 diarios)" "$cmd"
        print_info "Tarea cron: trunca logs en lugar de eliminarlos (preserva auditoría)"
    fi
}

# RESUMEN FINAL
print_summary() {
    print_header "RESUMEN DE CONFIGURACIÓN"
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}Se ejecutó en modo DRY-RUN (sin cambios reales)${NC}"
        echo ""
        echo "Para aplicar la configuración, ejecuta:"
        echo -e "${GREEN}$0${NC}"
        echo "y responde 'no' a la pregunta de DRY-RUN"
    elif [ "$PROCEED" = true ]; then
        echo -e "${GREEN}✓ Entorno configurado correctamente${NC}"
        echo ""
        echo "Próximos pasos:"
        echo "  1. Reinicia tu sesión o ejecuta: newgrp docker"
        echo "  2. Verifica que Docker funcione: docker ps"
        echo "  3. Inicia los servicios: docker-compose up -d"
    else
        echo "Configuración cancelada"
    fi
}

# MAIN
main() {
    show_menu
    
    if [ "$DRY_RUN" = true ] || [ "$PROCEED" = true ]; then
        print_header "EJECUTANDO CONFIGURACIÓN"
        
        step_update_packages
        step_install_dependencies
        step_configure_docker
        step_add_user_to_docker
        step_setup_cron
        
        print_summary
    fi
}

main
