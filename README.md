# WorkshopBanRep

Este repositorio contendrá todos los archivos relacionados al workshop de Prisma Cloud para Banco de La República.

# Cloud Secure Posture Management 🛡️

## Introducción 🚀

El módulo CSPM (Cloud Secure Posture Management) de Prisma Cloud está enfocado en la postura y gobierno de las aplicaciones y recursos desplegados en la nube pública estableciendo controles de compliance en distintas categorías (config, network, anomaly, data) y basados en distintos benchmarks del mercado tipo CIS, NIST, GDPR, HIPAA, PCI, benchmarks de CSPs. Esto se logra a través de la ingesta de metadata desde Prisma Cloud hacia las cuentas de nube pública a través de sus API endpoints. Prisma Cloud almacena, procesa y correlaciona esta data a través de sus engines y de ML para presentar una postura global de seguridad de los recursos desplegados en la nube pública.

Actualmente son soportadas las 5 nubes públicas principales; AWS, Azure, GCP, OCI y Alibaba. Próximamente se estará incluyendo IBM Cloud.

Para este workshop nos enfocaremos principalmente en seguridad de la red cloud con Prisma Cloud, esto implica poder ingestar desde Prisma Cloud los AWS flow logs (logs de actividad de red en la VPC) un vistazo general a la arquitectura de funcionamiento de Prisma Cloud es:

![Prisma Clod - CSPM Network Diagram](./images/CSPM_Net_Arch.png)

## Prerequisitos 🛠️

- Cuenta de AWS funcional, puede crear una free tier desde [este enlace.](https://aws.amazon.com/resources/create-account/)

_`Nota: todas las actividades ejecutadas dentro de la cuenta de AWS están dentro del bundle Free Tier por lo que no incurrirá en costos para la ejecución de este Workshop.`_

## Datos a tener en cuenta 🔍

- `Url de acceso a Prisma Cloud: https://apps.paloaltonetworks.com`
- `Usuario: su correo electrónico.`
- `Contraseña: su contraseña configurada.`
- `No olvide configurar su MFA, puede hacerlo con el mismo correo del usuario.`

## Habilitar AWS Flow Logs para Prisma Cloud 🌐

**Objetivo:** Habilitar la visibilidad de los AWS flow logs para que Prisma Cloud pueda detectar exposición y anomalías en las conexiones.

**Actividades:**

1. Crear un Cloudwatch Log Group en AWS, para ello seleccione **Servicios >> Cloudwatch >> Logs >> Crear Log Group** Asigne el nombre de su preferencia.

   ![Create Log Group](./images/LogGroup.png)

2. Habilitar flow logs dentro de la AWS VPC, para ello seleccione **Servicios >> VPC >> Sus VPCs**

- **Seleccione su VPC (Default)** luego seleccione el botón **Acciones >> Crear Flow Log**

- Seleccione el filtro en **Todo**, el destino debe ser **Enviar a CloudWatch Logs,** busque y seleccione el Log Group creado en el punto 1.

- En una nueva ventada de AWS cree un Rol IAM para el envío de los Flow Logs a CloudWatch, puede encontrar un tutorial en [este enlace.](https://docs.aws.amazon.com/es_es/vpc/latest/userguide/flow-logs-cwl.html#flow-logs-iam-role)

- Avise al instructor una vez creado el rol para revisar este y asegurar qué la política de confianza se haya configurado de manera adecuada.

- En la ventana inicial de AWS, asigne el rol recién creado y de click en Crear Flow Log.
  ![Create VPC Flow Log to Cloudwatch Log group](./images/FlowLog.png)

## Integración de cuenta de nube pública 🌐

**Objetivo:** Integrar la cuenta de AWS a Prisma Cloud para realizar la ingesta de datos y a partir de allí revisar cual es el estado de la gobernanza de los recursos desplegados en la nube pública.

**Actividades:**

1. Integrar la cuenta de AWS, para ello inicie sesión dentro de Prisma Cloud, allí vamos a seleccionar la opción **Settings >> Cloud Accounts >> Add Cloud Account**
   ![Add Cloud Account PC](./images/PC_AddAcc.png)

- A partir de allí seleccione: **AWS → Account → Desactive la opción "Agentless Workload Scanning" → Next**

  ![Add AWS Account](./images/AddAWS.png)

- Ingrese el account ID de su cuenta AWS, [aquí un tutorial de cómo encontrarlo](https://docs.aws.amazon.com/es_es/accounts/latest/reference/manage-acct-identifiers.html), y un **nombre para la cuenta en Prisma Cloud.**

- Para crear los recursos necesarios en AWS seleccione el botón **Create IAM Role**, esto lo redirigirá a AWS en su navegador (vigencia del enlace: 1 hora)

  ![Add AWS Account](./images/AddAWS2.png)

- En AWS seleccione la casilla de verificación _I acknowledge that AWS CloudFormation might create IAM resources with custom names_ y luego de click en el botón "Crear"

- Una vez finalizada la creación de los recursos en AWS seleccione la opción **Outputs**, allí encuentra el ARL del rol IAM creado, **copie el valor**, regrese a Prisma Cloud y peguelo en el campo **IAM Role ARN**

- Dentro del Account Group seleccione **Workshop BanRep** y de click en **Next**

  ![Add AWS Account](./images/AddAWS3.png)

- Revise el status (puede que deba esperar unos segundos) y de click en **Save and Close**

  ![Add AWS Account](./images/AddAWS4.png)

## Controles de Network en Prisma Cloud 🌐

Prisma cloud dispone de +1200 controles construidos qué son agrupados en +90 benchmarks de cumplimiento, entre ellos hay 44 controles para network. A partir de allí se puede robustecer tanto cómo se necesite y se requiera la gobernanza de la red en AWS a través de controles custom creados en Prisma Cloud.

**Objetivo:** Dar un breve vistazo a las políticas de red predefinidas en Prisma Cloud.

**Actividades:**

1. Revisar controles (políticas) de Prisma Cloud para el vector de ataque Network. Para ello vamos a Prisma Cloud, seleccionamos la opción **Policies >> Overview** y aplicamos los siguientes filtros: `Policy Type = Network` y `Cloud Type = AWS`

   ![Network Controls Prisma Cloud](./images/NetControls.png)

- En la parte de abajo encontrará las controles para los filtros seleccionados, preste especial atención a los campos `Description`, `Severity` y `Category` ellos indican: El detalle del control, y como catalogarlo si ocurre un incumplimiento.

- Del lado derecho tiene la columna **actions**, seleccione el icono del lápiz para cualquier control, allí podrá revisar con mayor detalle cada control.

_`Nota: Puede navegar por la interfaz tanto cómo desee para revisar los controles con detalle y entender cada uno de ellos.`_

## Real Time Network Revision con RQL 🌐

**Objetivo:** Conocer y revisar cuales son los hallazgos dentro de la red de mi nube pública

**Actividades:**

1. Entendiendo RQL (Resource Query Language): El motor RQL es el corazón del módulo CSPM de Prisma Cloud, en su mayoría, cada control (política) está atado a una query qué lo qué hace es buscar aquellos recursos qué hagan match y en consecuencia reportar el incumplimiento. El motor RQL es el encargado de interpretar y correr las queries de cada uno de los controles y por ende mantener actualizado el overview de la postura y gobierno en nube. Hay 3 tipos básicos de query en RQL: **Config, network & event.** Cada una de ellas enfocadas en detectar distintos tipos de brechas y/o vulnerabilidades en la nube pública.

Para el caso específico de Network, Prisma Cloud cuenta con 2 engines de análisis de datos de red, el primero es **Network Config Analyzer** encargado de asegurar la configuración de las redes en la nube pública. El segundo es **Network Flow Analyzer** encargado de analizar incidentes dentro de las redes en la nube pública.

Para hacer uso de cualquiera de los dos engines basta con situarse en el módulo **Investigate** y luego iniciar una query así:

- Network Config Analyzer: `config from network...`
- Network Flow Analyzer: `network from...`

El módulo Investigate es didáctico y te sugiere opciones para completar tu query.

![RQL Example](./images/RQLExample.png)

2. Probar RQL's de ejemplo: para esta actividad se sugiere hacer el despliegue de algunas instancias EC2 en AWS dentro del free tier y generar algunas conexiones de red para poder obtener resultado de los datos de las RQL en Prisma Cloud.

**`Hacer terrraform template qué sirva para esto.`**

Copie y pegue en el módulo de Investigate cualquiera de las siguientes RQL:

- Buscar instancias EC2 qué permitan el acceso por puertos 80/443 desde Internet:

```
config from network where source.network = '0.0.0.0/0' and address.match.criteria = 'full_match' and dest.resource.type = 'Instance' and dest.cloud.type = 'AWS' and protocol.ports in ( 'tcp/80' , 'tcp/443' )
```

- Buscar instancias EC2 que tienen acceso desde IPs no confiables:

```
config from network where source.network = UNTRUST_INTERNET and dest.resource.type = 'Instance' and dest.cloud.type = 'AWS' and protocol.ports in ('tcp/0:79','tcp/81:442','tcp/444:65535') and effective.action = 'Allow'
```

- Buscar servicios PaaS en AWS expuestos a internet:

```
config from network where source.network = '0.0.0.0/0' and dest.resource.type = 'PaaS' and dest.cloud.type = 'AWS'
```

Para cada uno de los resultados de las queries anteriores puede ver el Network Path Analysis, el cual le muestra la ruta de acceso desde internet hasta el recurso.

![Network Path Analysis](./images/NetPath.png)

Puede explorar la configuración exacta de cualquiera de los recursos qué hagan match con la consulta así:

![Resource Details Network Path](./images/ResourceDetails.png)

- Ver tráfico desde internet e IPs sospechosas hacia bases de datos RDS.

```
network from vpc.flow_record where source.publicnetwork IN ( 'Suspicious IPs' , 'Internet IPs' ) and dest.resource IN ( resource where role IN ( 'AWS RDS' , 'Database' ) )
```

- Ver tráfico hacía instancias públicas

```
network from vpc.flow_record where source.publicnetwork IN ( 'Internet IPs' ) and protocol = 'TCP' AND dest.port IN ( 21,23,80)
```

- Buscar instancias con vulnerabilidades recibiendo tráfico de internet:

```
network from vpc.flow_record where dest.resource IN ( resource where finding.type IN ( 'Host Vulnerability' ) AND finding.name IN ( 'CVE-2017-5754', 'CVE-2017-5753', 'CVE-2017-5715' ) )  and bytes > 0
```

- Buscar recursos de un segmento de red qué están enviando tráfico hacía internet:

```
network from vpc.flow_record where cloud.account=account_name AND source.ip IN(172.31.0.0/12,10.0.0.0/8) AND dest.publicnetwork IN 'Internet IPs' AND bytes > 0
```

- Buscar instancias EC2 qué son accesibles desde internet por puertos SSH y RDP:

```
config from network where source.network = UNTRUST_INTERNET and dest.resource.type = 'Instance' and dest.cloud.type = 'AWS' and effective.action = 'Allow' and protocol.ports in ( 'tcp/22' , 'tcp/3389' )
```

- Buscar bases de datos RDS qué están accesibles desde internet por puerto 3306:

```
config from network where source.network = UNTRUST_INTERNET and dest.resource.type = 'Interface' and dest.cloud.type = 'AWS' and dest.network.interface.owner in ( 'amazon-rds' ) and protocol.ports in ( 'tcp/3306')
```

- Buscar instancias EC2 qué están enviando tráfico hacia destinos sospechosos en internet:

```
config from network where source.resource.type = 'Instance' and source.cloud.type = 'AWS' and dest.network = UNTRUST_INTERNET
```

Si desea revisar más ejemplos puede consultar el RQL Reference en [este enlace.](https://docs.prismacloud.io/en/classic/rql-reference/rql-reference/network-query/network-query)

Los resultados de estas queries son similares a la siguiente imagen:

![RQL Query Results](./images/RQLResults.png)

Finalmente Prisma Cloud ofrece un gráfico de red inteligente qué agrega y relaciona los recursos monitoreados por Prisma Cloud para visualizar y entender las conexiones de red, este puede ser activado en la esquina superior derecha del módulo **Investigate.**

![Network Intelligent Graph](./images/NetworkGraph.png)

**Toda la documentación oficial puede consultarla en [este enlace.](https://docs.prismacloud.io/en/classic/cspm-admin-guide/investigate-incidents-on-prisma-cloud/investigate-network-incidents-on-prisma-cloud)**

## Creando mis controles de red a medida 🌐

**Objetivo:** Crear un control (política) custom a medida para el cliente dentro de Prisma Cloud.

**Actividades:**

1. Crear un control de red custom, para ello vamos a ir a Prisma Cloud y seleccionar la opción **Policies >> Add Policy >> Network**

![Custom Network Control Prisma Cloud](./images/CustomPolicy.png)

En la ventana qué se despliega ingrese los siguientes datos:

- `Policy Name:` SuNombre-Network
- `Description:` CustomNetwork Control for BanRep Workshop
- `Severity:` Medium
- `Query`: No olvide oprimir **Search** después de insertar la RQL.

```
config from network where source.network = '0.0.0.0/0' and address.match.criteria = 'full_match' and dest.resource.type = 'Instance' and dest.cloud.type = 'AWS' and protocol.ports in ( 'tcp/80' , 'tcp/443' )
```

- `Recommendations for Remediation:` Test Control, Not needed.

Presione **Save** para guardar el control.

2. Revisar el control creado. Dentro de la opción **Policies >> Overview** busque por el nombre del control asignado y verifique qué fue creado satisfactoriamente.

## Visibilizando los incumplimientos 🌐

**Objetivo:** Crear una regla de alerta para qué envíe un correo de notificación en el evento de incumplimiento del control.

**Actividades:**

1. Crear el "Alert Rule" en Prisma Cloud para el control custom creado hace un momento con integración vía correo a su email. Para ello seleccione **Alerts >> Alert Rules >> Add Alert Rule**, en el nuevo wizard incluya los siguientes datos:

- `Name`: SuNombre-Alert
- `Alert Notifications`: True
- `Account Group`: Seleccione su cuenta AWS
- `Assign Policies`: Busque la policy creada por usted mismo en el punto anterior y seleccione su check (a la izquierda)
- `Configure notifications`: Seleccione **Emails** y digíte el suyo en el primer campo. Habilite el botón deslizante a la derecha del email.

Oprima **Next y Save.**

![Create Alert Rule](./images/AlertRule.png)

2. Crear una instancia EC2 con el archivo terraform `./aws/main.tf`, esta EC2 tendrá exposición a internet por los puertos 80 y 443 y este será alertado por Prisma Cloud cómo incumplimiento.

- Descargue el archivo `./aws/main.tf` a su equipo (también puede copiar y pegar su contenido en un archivo con el mismo nombre)
- En su navegador abra la consola de AWS y abra una CloudShell, allí cargue el archivo descargado (o generado) y ejecute los siguientes comandos (línea por línea):

```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```

![AWS Cloud Shell](./images/CloudShell.jpg)

- Revise en la consola de AWS en el servicio **EC2 >> Instancias** qué ya haya una instancia corriendo con el nombre "EC2-Workshop" Seleccionela y revise los detalles de seguridad qué tengan los puertos 443 y 80 abiertos.

- A partir de aquí sólo resta esperar que Prisma Cloud realice la detección y notifique el incumplimiento a su correo electrónico.

`Nota:` _Tenga en cuenta qué la detección y alertamiento por parte de Prisma Cloud conlleva un tiempo debido a qué la funcionalidad es 100% Agentless._

# Code & Application Security 🛡️

## Introducción 🚀

Prisma Cloud Code Security está pensado para asegurar desde una fase temprana el compliance en el código IaC, y evitar qué un error o no cumplimiento pueda traducirse en cientos de recursos con errores de configuraciones y/o vulnerabilidades en runtime. Actualmente soporta una amplia colección de recursos IaC cómo Dockerfile, manifiestos de Kubernetes, Helm Charts, Terraform, Terraform Plans, Cloudformation, Serverless, entre otros. Entre las principales integraciones se tienen:

1. Escaneo agentless en repositorios de IaC alojados en GitHub, Azure Repos, Bitbucket, entre otros.
2. Integración con herramientas CI/CD como AWS Code Build, Azure DevOps, GitHub Actions, Circle CI, Jenkins, entre otras.
3. Real Time Scanning en los IDE's de desarrollo VSC y JetBrains.

## Prerequisitos 🛠️

- Python instalado.
- VSC instalado.
- Git instalado en su laptop.
- Cuenta de GitHub.
- Usuario de Prisma Cloud.

## Analizando mis repositorios de IaC con Prisma Cloud 🌐

**Objetivo:** conectar un repositorio de GitHub que contenga templates/archivos de IaC a Prisma Cloud para poder detectar todos los hallazgos de incumplimiento y malas prácticas en Security as Code.

**Actividades:**

1. Hacerle un fork al repositorio ["CfnGoat"](https://github.com/bridgecrewio/cfngoat.git) dentro de su cuenta de GitHub.
   ![CfnGoat Fork](./images/CFNGoat_Repo.png)

2. Ingresar a Prisma Cloud con su usuario y contraseña asignado por Netdata.

   `Prisma Cloud URL: https://apps.paloaltonetworks.com/apps`

3. Integrar GitHub cómo Provider en Prisma Cloud, para ello seleccione las opciones: **Settings >> Code & Build Providers >> Code Repositories >> Add**
   ![Add GitHub Provider](./images/GitHub_Provider.png)
4. Seleccionar GitHub de la lista de Providers, dar click en **Previous - Configure Account** y luego en **Authorize**, seleccione únicamente el repositorio **CfnGoat** cómo el autorizado.
   ![Authorize GitHub](./images/GitHub_Authorize.png)
5. Al finalizar la autorización de acceso al repositorio, Prisma Cloud automáticamente detecta los incumplimientos de controles en IaC y muestra los hallazgos, estos resultados pueden ser consultados desde la opción: **Application Security >> Projects >> Overview** haciendo el filtro del repositorio adecuado.
   ![Repo Scanning Results](./images/Repo_Results.png)

<!-- ## Asegurando el cumplimiento en IaC con Prisma Cloud - Checkov

**Objetivo:** instalar el motor de escaneo de IaC **_Checkov_**

**Actividades:**

1. Para poder instalar Checkov previamente debe tener instalado Python >= 3.10, puede descargarlo en [este enlace](https://www.python.org/downloads/) y realizar su instalación por defecto.
2. Puede verificar la versión de Python instalado ejecutando el siguiente comando en su CLI:

````

python --version

```

3. Instalar Checkov, puede utilizar cualquiera de los dos comandos:

```

pip install checkov
pip3 install checkov

```

4. Descargue o clone el repositorio "xxxxx" en su maquina local.

5.

## Asegurando el cumplimiento en Tiempo Real desde el IDE

**Objetivo:** instalar la extensión de Checkov en Visual Studio Code.

**Actividades:**

1. Para poder instalar la extensión de Checkov, previamente debe tener instalado Visual Studio Code, puede descargarlo en [este enlace](https://code.visualstudio.com/download) y realizar su instalación por defecto.

2. Abrir Visual Studio Code e instalar la extensión de Checkov en la opción: **Extensiones**, **buscar “Checkov”** dar click en **instalar.**
   ![VSC Checkov Extension](./images/VSC_Checkov_Ext.png)
-->

## Asegurando mi proceso de despliegue de IaC con GitHub Actions 🌐

**Objetivo:** Crear un pipeline en GitHub Actions con un Job de Prisma Cloud qué escanee por incumplimientos de controles en IaC.

**Actividades:**

1. Obtener una Access Key y Secret Key de Prisma Cloud, puede encontrar el [paso a paso para crearla en este enlace](https://docs.prismacloud.io/en/classic/cspm-admin-guide/manage-prisma-cloud-administrators/create-access-keys)

_`Nota: Asegúrese de establecer una expiración para la access key, esta es la buena práctica`_

2. Ir a Github y hacerle un fork a este repositorio en su cuenta de GitHub (mismos pasos que en el laboratorio anterior).

3. En su nuevo repositorio, seleccionar las siguientes opciones **Settings >> Secrets and variables >> Actions >> New repository secret** y crear las siguientes variables en GitHub:

- `Name: BC_API_KEY `
- `Secret: AccessKey::SecretKey`

  ![Create Secrets in GitHub](./images/GitHub_Secrets.png)

_`Nota: Asegúrese de no incluir espacios en blanco en el secret y de separar los dos valores por los caracteres "::"`_

4. Configurar el Workflow de GitHub Actions para escanear los archivos de terraform del directorio `./terraform`, para ello seleccione **Actions >> Buscar Prisma Cloud >> Configure**
   ![Prisma Cloud Workflow](./images/GitHub_Prisma.png)

5. Reemplace todo el contenido del editor con el siguiente bloque de código y realice un **commit de los cambios en la rama main** Deje todo lo demás por defecto.

```
name: Prisma Cloud IaC Scan

on:
push:
branches: ["main"]
pull_request:
branches: ["main"]
#schedule:
#- cron: '26 17 \* \* 0'

jobs:
prisma_cloud_iac_scan:
runs-on: ubuntu-latest
name: Run Prisma Cloud IaC Scan to check Compliance
steps: - name: Checkout
uses: actions/checkout@v3 - name: Run Scan on IaC .tf files in the repository
uses: bridgecrewio/checkov-action@master
id: iac-scan
env:
PRISMA_API_URL: https://api2.prismacloud.io
with:
api-key: ${{ secrets.BC_API_KEY }}
directory: ./terraform
framework: terraform
quiet: true
use_enforcement_rules: true
#open_api_key: 'xxxxxx'

```

![GitHub Prisma Cloud IaC Commit](./images/GitHub_Commit.png)

_`Nota: el código anterior también está disponible en el archivo ./workflow.yml en este repositorio`_

Toda la información para configuración de la tarea de escaneo IaC de Prisma puede encontrarla en [este enlace](https://github.com/bridgecrewio/checkov-action) y el command reference completo lo puede encontrar en [este enlace.](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html)

6. Realice un commit o push cualquiera dentro del repositorio, puede abrir el archivo `./README.md` y agregar al final del archivo una linea de texto cualquiera y realizar el commit de los cambios para disparar el Pipeline de escaneo de los archivos de terraform.

7. En cada evento push en el repositorio se va a correr la tarea de escaneo IaC de Prisma Cloud, si desea ver los resultados del escaneo, puede ir a **Actions y seleccionar el último workflow** Al final puede encontrar el enlace directo a Prisma Cloud para ver los hallazgos en Prisma Cloud, pero también los va a encontrar en el mismo output del CLI.
   ![GitHub Actions Results](./images/GitHubActions_Results.png)

# Agradecimientos 👊

Este Workshop está destinado a fines educativos en ambientes de pruebas sobre la herramienta de Prisma Cloud en sus módulos CSPM y Code & App Sec.

Gracias por haber participado, esperamos qué haya sido de mucha utilidad y enriquecedor para su crecimiento profesional. Les animamos a todos a continuar explorando, aprendiendo y aplicando lo que han adquirido aquí en sus proyectos con Prisma Cloud. Manténganse conectados para futuros eventos y oportunidades de aprendizaje con **NETDATA INNOVATION CENTER**.

Esperamos verlos nuevamente en nuestros próximos eventos y talleres. ¡Hasta pronto y sigan innovando! 👋

_Made with Love 💙 by Cloud & Automate Team in [Netdata Innovation Center](https://www.netdatanetworks.com/). `THINKS BEYOND`_
