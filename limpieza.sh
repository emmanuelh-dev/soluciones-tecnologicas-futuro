#!/bin/bash
echo "Iniciando limpieza de logs en el entorno de Finanzas..."
# Truncar logs para ahorrar espacio
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} +
echo "Limpieza completada: \04/13/2026 20:23:26"
