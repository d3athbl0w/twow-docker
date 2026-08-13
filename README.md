# TurtleWoW 1.17.2 — Docker Environment Guide

Este repositorio contiene el entorno comprimido y reproducible en **Docker** para compilar y ejecutar tu fork privado de **TurtleWoW 1.17.2** en Windows utilizando **Docker Desktop**.

---

## 📁 Arquitectura del Proyecto

```text
D:\Dev\Vanilla\
│
├── patch_1172\                  <-- SOURCE C++ (Tu repositorio original)
│
├── TurtleWoW 1172\              <-- REPACK FUNCIONAL (Game Assets & Dump tw_world.sql)
│
└── path_1172_docker\            <-- ENTORNO DOCKER (Archivos creados)
    ├── docker-compose.yml
    ├── Dockerfile.server
    ├── Dockerfile.builder
    ├── .env.example
    ├── .env
    ├── .gitignore
    ├── README.md
    ├── config/
    │   ├── realmd.conf
    │   ├── mangosd.conf
    │   └── anticheat.conf
    ├── database/init/
    │   ├── 01-init-databases.sql
    │   ├── 02-init-logon.sh
    │   ├── 03-init-characters.sh
    │   ├── 04-init-logs.sh
    │   └── 05-init-world.sh
    └── scripts/
        ├── entrypoint-auth.sh
        ├── entrypoint-world.sh
        └── rebuild.sh
```

---

## 1. Requisitos Previos

* **Sistema Operativo:** Windows 10/11 (64-bit).
* **Docker Desktop:** Instalado y configurado con backend **WSL2** (recomendado).
* **RAM Mínima:** 8 GB recomendados (al menos 4 GB asignados a Docker Desktop).
* **Cliente TurtleWoW 1.17.2:** Instalado en tu máquina local.

---

## 2. Configuración Inicial

Abre PowerShell o CMD y dirígete al directorio Docker:

```powershell
cd D:\Dev\Vanilla\path_1172_docker
```

Si deseas modificar variables como la contraseña de MySQL o los puertos expuestos, edita el archivo `.env`:

```env
DB_ROOT_PASSWORD=mangos
DB_PORT=3306
AUTH_PORT=3724
WORLD_PORT=8091
```

---

## 3. Primer Build (Compilación del Core dentro de Docker)

Para compilar la imagen completa y construir los binarios de C++ desde el source (`patch_1172`), ejecuta:

```powershell
docker compose build
```

*Esto compilará `realmd` y `mangosd` dentro de un contenedor Linux de manera aislada sin alterar tu sistema operativo Windows.*

---

## 4. Primer Arranque e Inicialización de Bases de Datos

Para iniciar todos los servicios (`mariadb`, `authserver`, `worldserver`):

```powershell
docker compose up -d
```

### ¿Qué sucede durante el primer arranque?
1. MariaDB iniciará en el contenedor `turtlewow-mariadb`.
2. Se ejecutarán automáticamente los scripts en `database/init/`:
   * Creación de esquemas (`tw_logon`, `tw_world`, `tw_char`, `tw_logs`).
   * Importación de estructuras base (`_structure_*.sql`).
   * Importación del dump completo de mundo [`tw_world.sql`](file:///d:/Dev/Vanilla/TurtleWoW%201172/sql/tw_world.sql) (~191 MB).
   * Configuración automática de `realmlist` con el puerto `8091`.
3. Una vez `mariadb` esté en estado `healthy`, `authserver` (`realmd`) y `worldserver` (`mangosd`) arrancarán automáticamente.

---

## 5. Inspección de Logs

Para ver los logs en tiempo real de todos los servicios:

```powershell
docker compose logs -f
```

Para ver el log de un servicio específico:

```powershell
# Log del World Server
docker compose logs -f worldserver

# Log del Auth Server
docker compose logs -f authserver

# Log de la Base de Datos
docker compose logs -f mariadb
```

---

## 6. Conexión del Cliente de Juego (TurtleWoW 1.17.2)

1. Abre la carpeta de tu cliente de TurtleWoW 1.17.2.
2. Edita el archivo `realmlist.wtf`:
   ```text
   set realmlist 127.0.0.1
   ```
3. Ejecuta el cliente `WoW.exe`.
4. Inicia sesión con tus credenciales.

---

## 7. Conexión a la Base de Datos desde Windows

Puedes conectarte desde cualquier cliente MySQL (Navicat, DBeaver, MySQL Workbench, HeidiSQL) en Windows usando:

* **Host:** `localhost` (o `127.0.0.1`)
* **Puerto:** `3306`
* **Usuario:** `root`
* **Contraseña:** `mangos`

Bases de datos disponibles: `tw_logon`, `tw_world`, `tw_char`, `tw_logs`.

---

## 8. Desarrollo en C++ y Recompilación Incremental Rápida

Cuando edites archivos `.cpp` o `.h` en tu repositorio `D:\Dev\Vanilla\patch_1172` desde Windows:

### Opción A: Reconstruir imagen completa

```powershell
docker compose build
docker compose up -d
```

### Opción B: Incremental Rebuild ultra-rápido (Dev Profile)

Para aprovechar la caché `ccache` y recompilar solo los archivos modificados en segundos:

```powershell
docker compose --profile dev run --rm builder
docker compose restart authserver worldserver
```

---

## 9. Detener el Servidor

Para detener todos los servicios sin borrar tus datos ni tu base de datos:

```powershell
docker compose down
```

---

## 10. Reset Completo de la Base de Datos

Si deseas destruir los volúmenes de datos y volver a importar la base de datos limpia desde cero:

```powershell
docker compose down -v
docker compose up -d
```

---

## 11. Troubleshooting / Preguntas Frecuentes

### ¿El servidor World indica que no puede conectar a la DB?
Verifica que el servicio `mariadb` esté `healthy` ejecutando `docker compose ps`.

### ¿Los mapas o DBCs no cargan?
Asegúrate de que la carpeta [`D:\Dev\Vanilla\TurtleWoW 1172\data`](file:///d:/Dev/Vanilla/TurtleWoW%201172/data) contenga las subcarpetas `dbc`, `maps`, `vmaps`, `mmaps`.

### Entrar al terminal interactivo de un contenedor:

```powershell
# Entrar al contenedor del World Server
docker exec -it turtlewow-worldserver bash

# Entrar a MariaDB CLI dentro de Docker
docker exec -it turtlewow-mariadb mysql -u root -pmangos
```
