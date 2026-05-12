# Soluciones Tecnológicas del Futuro - Automatización DevOps

Proyecto académico de automatización DevOps para una empresa fintech en expansión. El objetivo es mostrar una base reproducible de infraestructura, contenedorización, automatización con AWS y un pipeline de integración continua con GitHub Actions.

## Integrantes

- Emmanuel Diaz Leal Hernandez
- Maria Fernanda De Leon Mendoza
- Matrícula: AL07092780
- Institución: Universidad Tecmilenio

## Objetivo

La solución está pensada para reducir tareas manuales, estandarizar despliegues y centralizar la observabilidad y la seguridad desde etapas tempranas.

## Componentes del proyecto

- Configuración de entorno Linux con Bash para instalar Docker, Python y Git, además de una tarea programada para limpieza de logs.
- Automatización de inventario de recursos AWS con Python y Boto3.
- Infraestructura como código con AWS CloudFormation en formato YAML.
- Contenedorización con Docker y orquestación local con Docker Compose.
- Pipeline de CI con GitHub Actions para validar scripts, plantilla de infraestructura, Docker Compose y la imagen Docker.

## Estructura del repositorio

- [limpieza.sh](limpieza.sh): automatización del entorno y mantenimiento básico.
- [aws_report.py](aws_report.py): inventario de buckets S3 e instancias EC2.
- [template.yaml](template.yaml): plantilla CloudFormation con EC2 y S3.
- [Dockerfile](Dockerfile): imagen Nginx para servir la vista estática del proyecto.
- [docker-compose.yml](docker-compose.yml): definición del servicio web en la red aislada finanzas-net.
- [.github/workflows/ci.yml](.github/workflows/ci.yml): pipeline de GitHub Actions.
- [config.yaml](config.yaml): configuración mínima de instancia.

## Configuración del entorno

El script [limpieza.sh](limpieza.sh) replica la automatización descrita en la actividad para Ubuntu en EC2:

- Actualiza el sistema.
- Instala Docker, Python 3 y Git.
- Habilita el servicio Docker.
- Agrega el usuario actual al grupo docker.
- Configura una tarea cron diaria para limpiar archivos .log en /var/log.

## Automatización con AWS

El script [aws_report.py](aws_report.py) usa Boto3 para consultar:

- Buckets S3 disponibles.
- Estado de las instancias EC2.

La región se toma de la variable AWS_REGION y, si no existe, usa us-east-1.

## Infraestructura como código

La plantilla [template.yaml](template.yaml) define:

- Una instancia EC2 t2.micro con el rol preexistente LabRole.
- Un bucket S3 para el entorno del proyecto.

## Contenedorización

La imagen Docker se apoya en Nginx para servir una página estática del proyecto. Esto permite validar el empaquetado del front de presentación de la actividad y mantener una construcción simple y reproducible.

## CI con GitHub Actions

El pipeline valida los puntos críticos del repositorio:

- Sintaxis de Bash en [limpieza.sh](limpieza.sh).
- Compilación de [aws_report.py](aws_report.py).
- Carga de la plantilla YAML de CloudFormation.
- Validación de [docker-compose.yml](docker-compose.yml).
- Construcción de la imagen definida en [Dockerfile](Dockerfile).

## Ejecución local

1. Ejecutar el script de entorno en una instancia Ubuntu con permisos de sudo.
2. Correr python3 aws_report.py con credenciales válidas de AWS.
3. Validar la plantilla con la consola o con una herramienta compatible de CloudFormation.
4. Construir la imagen con Docker y levantar el servicio con Docker Compose.

## Observabilidad y seguridad

La propuesta de la actividad contempla monitoreo con CloudWatch, alarmas con SNS y controles DevSecOps para reducir errores antes del despliegue. Este repositorio deja la base documentada y validada para integrar esos componentes en iteraciones posteriores.
