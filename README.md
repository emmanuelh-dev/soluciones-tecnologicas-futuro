# Automatización DevOps - Soluciones Tecnológicas del Futuro

**Presentado por:** Emmanuel Diaz Leal Hernandez / Maria Fernanda De Leon Mendoza  
**Matrícula:** AL07092780  
**Institución:** Universidad Tecmilenio

---

## 1. Introducción y Estrategia

Este proyecto presenta la implementación de un ecosistema DevOps automatizado para **Soluciones Tecnológicas del Futuro**, una empresa fintech en fase de expansión. La estrategia se centra en romper los silos tradicionales entre desarrollo y operaciones para fomentar una responsabilidad compartida.

### Objetivos Principales

- **Reducción de errores manuales:** Mediante la adopción de Infraestructura como Código (IaC).
- **Agilidad en el despliegue:** Implementación de pipelines de CI/CD para entregas frecuentes y estables.
- **Observabilidad Proactiva:** Monitoreo continuo del rendimiento y salud del sistema con AWS CloudWatch.
- **Seguridad Integrada (DevSecOps):** Escaneo de vulnerabilidades desde las etapas iniciales del desarrollo.

---

## 2. Configuración del Entorno (Linux & Bash)

### Script de Automatización Interactivo

Para garantizar un entorno de trabajo reproducible, se utiliza una instancia EC2 con Ubuntu. La automatización de la configuración se realiza mediante el script `setup_env.sh` con menú interactivo que permite validar cambios antes de ejecutarlos.

### Uso del Script de Setup

```bash
# Hacer el script ejecutable
chmod +x setup_env.sh

# Ejecutar el script interactivo
./setup_env.sh
```

**El script realiza:**
- ✓ Actualización de paquetes del sistema (`apt update && apt upgrade`)
- ✓ Instalación de Docker, Python3-pip y Git
- ✓ Configuración del servicio Docker (enable y start)
- ✓ Adición del usuario actual al grupo `docker` (sin requerir `sudo`)
- ✓ Creación de tarea cron para limpieza de logs diarios a las 00:00

**Características:**
- ✓ Menú interactivo con confirmaciones en cada paso
- ✓ Modo DRY-RUN para simular sin cambios reales
- ✓ Validaciones previas a ejecución
- ✓ Salida con colores para mejor legibilidad

**⚠️ Importante:** Este script requiere permisos de `sudo` en el sistema. Está diseñado para entornos basados en Debian/Ubuntu (EC2, instancias Linux). No ejecutar en macOS o Windows sin adaptaciones.

---

## 3. Automatización de Recursos (Python & Boto3)

La gestión programática de la nube de AWS se implementa utilizando Python y el SDK Boto3. Este enfoque permite una auditoría eficiente de recursos y control de costos dentro de las restricciones del Learner Lab.

### Script de Reporte AWS

```bash
python3 aws_report.py
```

**Funcionalidades:**
- Lista todos los buckets S3 disponibles
- Muestra el estado de instancias EC2
- Reporta uso de recursos para optimización de costos

**Configuración:**
- Region por defecto: `us-east-1` (configurable via variable `AWS_REGION`)
- Requiere credenciales de AWS en `~/.aws/credentials` o variables de entorno

---

## 4. Infraestructura como Código (AWS CloudFormation)

Se utiliza una definición declarativa de la infraestructura mediante plantillas YAML de CloudFormation. Esto asegura que el entorno sea consistente y elimina configuraciones manuales propensas a errores.

### Recursos Aprovisionados

- **Instancia EC2 (t2.micro):** Servidor de aplicación
- **Bucket S3:** Almacenamiento de datos financieros

### Seguridad

- Uso exclusivo del rol preexistente **LabRole** para cumplir políticas de IAM
- Respeto a límites de recursos del Learner Lab (máximo 9 instancias EC2)

**Archivo:** [template.yaml](template.yaml)

---

## 5. Orquestación y Pipeline de CI/CD

El flujo de entrega continua minimiza el tiempo entre el commit del código y su disponibilidad en producción.

| Componente | Función |
|-----------|---------|
| **Docker** | Contenedorización de la aplicación con Nginx |
| **Docker Compose** | Orquestación en red privada (`finanzas-net`) |
| **GitHub** | Fuente única de verdad y control de versiones |
| **GitHub Actions** | Automatización: Validación → Build → Deploy |

### GitHub Actions Workflow

El workflow de `Deploy` se ejecuta automáticamente en cada push a `main`:

```
1. Validate    → Valida scripts Bash, YAML y Python
2. Build       → Construye imagen Docker
3. Deploy      → Despliega a servidor vía SSH
4. Verify      → Verifica contenedores activos
```

**Requisitos para activar el Deploy:**

Configura los siguientes secretos en tu repositorio GitHub:

```
Settings → Secrets and variables → Actions → New repository secret
```

- **HOST:** IP o hostname del servidor
- **PORT:** Puerto SSH (default: 22)
- **USERNAME:** Usuario SSH del servidor
- **SSHKEY:** Clave privada SSH

**Generar clave SSH:**
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_fintech -N ""
ssh-copy-id -i ~/.ssh/id_fintech.pub user@server-ip
```

**Archivo workflow:** [.github/workflows/deploy.yml](.github/workflows/deploy.yml)

---

## 6. Monitoreo y Seguridad (DevSecOps)

### Validaciones Automatizadas en el Pipeline

1. **Análisis Estático (SAST):**
   - Validación sintáctica de scripts Bash
   - Validación de archivos YAML
   - Compilación de scripts Python

2. **Seguridad de Contenedores:**
   - Construcción y validación de Dockerfile
   - Uso de imágenes base ligeras (alpine)

3. **Cumplimiento Automatizado:**
   - Verificación de estructura de proyecto
   - Pruebas de conectividad SSH post-deployment

### Monitoreo en AWS CloudWatch

Se establecen tableros y alarmas para:
- CPU de instancias EC2
- Latencia y throughput de red
- Estado de buckets S3

---

## 7. Estructura del Proyecto

```
soluciones-tecnologicas-futuro/
├── setup_env.sh              # Script de configuración interactivo
├── limpieza.sh              # Script de limpieza de logs
├── aws_report.py            # Reporte de recursos AWS
├── Dockerfile               # Definición de imagen Docker
├── docker-compose.yml       # Orquestación de servicios
├── template.yaml            # Plantilla CloudFormation
├── config.yaml              # Configuración de aplicación
├── .github/
│   └── workflows/
│       └── deploy.yml       # Pipeline de CI/CD
├── README.md                # Este archivo
└── .gitignore               # Archivos a ignorar
```

---

## 8. Instrucciones de Uso

### Desarrollo Local

```bash
# 1. Clonar repositorio
git clone https://github.com/emmanuelh-dev/soluciones-tecnologicas-futuro.git
cd soluciones-tecnologicas-futuro

docker-compose up -d
# 2. Ejecutar script de setup (Linux/Ubuntu)
chmod +x setup_env.sh
./setup_env.sh

# 3. Iniciar servicios
docker compose up -d

# 4. Verificar estado
docker ps
```

### Despliegue Automatizado (GitHub Actions)

1. Configura secretos SSH en GitHub
2. Haz push a `main`:
   ```bash
   git add .
   git commit -m "Cambios para deployment"
   git push origin main
   ```
3. Observa el workflow en **Actions**
4. El pipeline validará, construirá y desplegará automáticamente

---

## 9. Notas de Seguridad

- ⚠️ **Nunca** commitear credenciales o claves privadas
- ⚠️ Claves SSH deben tener permisos `600` (`chmod 600 ~/.ssh/id_fintech`)
- ✓ Secretos almacenados en GitHub Secrets (cifrados y no visibles)
- ✓ El pipeline no expone credenciales en logs

---

## 10. Referencias

- **AWS CloudFormation:** https://docs.aws.amazon.com/cloudformation/
- **GitHub Actions:** https://docs.github.com/en/actions
- **Docker Compose:** https://docs.docker.com/compose/
- **Boto3:** https://boto3.amazonaws.com/v1/documentation/api/latest/

---

**Repositorio:** https://github.com/emmanuelh-dev/soluciones-tecnologicas-futuro
