# WorkshopBanRep

Este repositorio contendrá todos los archivos relacionados al workshop de Prisma Cloud para Banco de La República.

# Code & Application Security

## Introducción

Prisma Cloud Code Security está pensado para asegurar desde una fase temprana el compliance en el código IaC, y evitar qué un error o no cumplimiento pueda traducirse en cientos de recursos con errores de configuraciones y/o vulnerabilidades en runtime. Actualmente soporta una amplia colección de recursos IaC cómo Dockerfile, manifiestos de Kubernetes, Helm Charts, Terraform, Terraform Plans, Cloudformation, Serverless, entre otros. Entre las principales integraciones se tienen:

1. Escaneo agentless en repositorios de IaC alojados en GitHub, Azure Repos, Bitbucket, entre otros.
2. Integración con herramientas CI/CD como AWS Code Build, Azure DevOps, GitHub Actions, Circle CI, Jenkins, entre otras.
3. Real Time Scanning en los IDE's de desarrollo VSC y JetBrains.

## Prerequisitos:

- Python instalado.
- VSC instalado.
- Cuenta de GitHub.

# Analizando mis repositorios de IaC con Prisma Cloud

**Objetivo:** conectar un repositorio de GitHub que contenga templates/archivos de IaC a Prisma Cloud para poder detectar todos los hallazgos de incumplimiento y malas prácticas en Security as Code.

**Actividades:**

- Hacerle un fork al repositorio "" dentro de su cuenta de GitHub.

# Asegurando mi cumplimiento en IaC con Prisma Cloud - Checkov

**Objetivo:** instalar el motor de escaneo de IaC **_Checkov_**

**Actividades:**

- Para poder instalar checkov previamente debe tener instalado Python >= 3.10, puede descargarlo en [este enlace](https://www.python.org/downloads/) y realizar su instalación por defecto.
-
