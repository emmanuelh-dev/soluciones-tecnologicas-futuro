#!/bin/bash
# setup_env.sh - Automatización de entorno para Fintech App

set -e
set -x

echo "Actualizando y mejorando paquetes del sistema..."
sudo apt update -y
sudo apt upgrade -y

echo "Instalando Docker, Python3-pip y Git..."
sudo apt install -y docker.io python3-pip git

echo "Configurando servicio Docker..."
sudo systemctl enable --now docker

USER_NAME=$(whoami)
if ! getent group docker | grep -q "\b${USER_NAME}\b"; then
	echo "Añadiendo usuario ${USER_NAME} al grupo docker. Es necesario un reinicio de sesión para que el cambio surta efecto."
	sudo usermod -aG docker "${USER_NAME}"
fi

CRON_JOB="0 0 * * * /usr/bin/find /var/log/ -type f -name '*.log' -delete"
(sudo crontab -l 2>/dev/null | grep -Fv "/var/log/*.log"; echo "${CRON_JOB}") | sudo crontab -

echo "Entorno configurado correctamente."
