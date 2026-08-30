# 🐢 TurtleWoW 1.17.2 — Docker Environment & Server Guide

Entorno de desarrollo y ejecución en **Docker & Docker Compose** para el emulador de **TurtleWoW 1.17.2** (basado en CMaNGOS / VMaNGOS Custom).

---

## 🔗 Repositorios Oficiales y Assets

* **Core Source Code (C++):** [https://github.com/d3athbl0w/twow-1172](https://github.com/d3athbl0w/twow-1172)
* **Docker Environment:** [https://github.com/d3athbl0w/twow-docker](https://github.com/d3athbl0w/twow-docker)
* **Official Game Data (`data.zip` con DBCs, Maps, VMaps, MMaps):**  
  [https://github.com/d3athbl0w/twow-1172/releases/download/data/data.zip](https://github.com/d3athbl0w/twow-1172/releases/download/data/data.zip)

---

## 📁 Estructura del Proyecto

```text
Vanilla/
├── twow-1172/                    <-- SOURCE C++ (Opcional en Host para desarrollo)
│   ├── src/
│   ├── sql/
│   └── CMakeLists.txt
│
└── path_1172_docker/             <-- ENTORNO DOCKER (Standalone)
    ├── docker-compose.yml
    ├── Dockerfile.server
    ├── Dockerfile.builder
    ├── .env.example
    ├── .env
    ├── config/
    │   ├── realmd.conf
    │   ├── mangosd.conf
    │   └── anticheat.conf
    ├── database/
    │   ├── init/                 <-- Scripts de inicialización automática
    │   └── sql/                  <-- Estructuras y dump tw_world.sql
    ├── data/                     <-- Assets extraídos (dbc, maps, vmaps, mmaps)
    ├── logs/
    └── scripts/
        ├── build.ps1             <-- Asistente de compilación y descarga para Windows
        ├── build.sh              <-- Asistente de compilación y descarga para Linux/macOS
        ├── download_data.ps1     <-- Descarga y extracción automática de data.zip (Windows)
        ├── download_data.sh      <-- Descarga y extracción automática de data.zip (Linux)
        ├── entrypoint-auth.sh
        ├── entrypoint-world.sh
        └── rebuild.sh
```

---

## ⚡ Guía Rápida de Instalación (Plug & Play)

No necesitas clonar el código fuente de C++ manualmente si solo deseas ejecutar el servidor. Docker lo descargará y compilará automáticamente.

### 1. Descargar los Assets del Juego (`data/`)

Ejecuta el script para descargar y descomprimir automáticamente los mapas, DBCs y geometrías (`~2.5 GB`):

#### En Windows (PowerShell):
```powershell
.\scripts\download_data.ps1
```

#### En Linux / macOS:
```bash
chmod +x scripts/*.sh
./scripts/download_data.sh
```

---

### 2. Compilar y Levantar los Servidores

Ejecuta directamente Docker Compose:

```powershell
docker compose up -d --build
```

*(O utiliza el asistente `.\scripts\build.ps1` que verifica dependencias automáticamente).*

#### Servicios iniciados:
* **`turtlewow-mariadb`**: Base de datos MariaDB 10.11 en el puerto `3306`.
* **`turtlewow-authserver`**: Servidor de autenticación (`realmd`) en el puerto `3724`.
* **`turtlewow-worldserver`**: Servidor de mundo (`mangosd`) en el puerto `8091`.

---

## 🛠️ Modo Desarrollo (Modificar Código C++)

Si deseas modificar código fuente C++, añadir scripts o personalizar el core:

1. Clona el repositorio de código fuente en la carpeta adyacente:
   ```bash
   git clone https://github.com/d3athbl0w/twow-1172.git ../patch_1172
   ```
2. Edita los archivos C++ en tu editor favorito (VS Code / Visual Studio / CLion).
3. Recompila instantáneamente con `ccache` sin reconstruir toda la imagen Docker:
   ```powershell
   docker compose --profile dev run --rm builder
   docker compose restart authserver worldserver
   ```


---

## 👤 Creación de Cuentas y Permisos

Para crear una cuenta de Administrador (Rango 4 / `SEC_ADMINISTRATOR`) con acceso total a comandos GM y Bots:

```powershell
docker exec turtlewow-mariadb mysql -u root -pmangos -e "INSERT INTO tw_logon.account (username, sha_pass_hash, rank, email) VALUES ('ADMIN', SHA1('ADMIN:ADMIN'), 4, 'admin@localhost');"
```
* **Usuario:** `ADMIN`
* **Contraseña:** `ADMIN`
* **Nivel GM (`rank`):** `4` (Administrador completo)

---

## 🎮 Conexión del Cliente de Juego (TurtleWoW 1.17.2)

1. Abre la carpeta de tu cliente de **TurtleWoW 1.17.2**.
2. Abre o crea el archivo `realmlist.wtf` y escribe:
   ```text
   set realmlist 127.0.0.1
   ```
3. Inicia `WoW.exe` e ingresa con:
   * **Usuario:** `ADMIN`
   * **Contraseña:** `ADMIN`

---

## 🤖 Comandos en el Juego (GM, Bots y Chat)

### 1. Activar Modo GM y Desbloquear Chat
Al ingresar con un personaje recién creado, activa el modo GM para quitar restricciones de chat y acceder a todos los comandos:
```text
.gm on
.level 60
```

### 2. Comandos de PartyBots (Bots de Grupo / Mazmorras)
* **Clonar a tu propio personaje como bot:**
  ```text
  .partybot clone
  ```
* **Añadir un bot existente a tu grupo:**
  ```text
  .partybot add NombrePersonaje
  ```
* **Asignar rol al bot:**
  ```text
  .partybot setrole tank
  .partybot setrole healer
  .partybot setrole dps
  ```
* **Órdenes de combate y movimiento:**
  ```text
  .partybot attackstart
  .partybot attackstop
  .partybot cometome
  .partybot remove
  ```

### 3. Comandos de BattleBots (Bots de Campos de Batalla)
* **Añadir bots a Warsong Gulch:**
  ```text
  .battlebot add warsong 10
  ```
* **Añadir bots a Arathi Basin:**
  ```text
  .battlebot add arathi 15
  ```
* **Añadir bots a Alterac Valley:**
  ```text
  .battlebot add alterac 40
  ```
* **Remover bots:**
  ```text
  .battlebot remove
  ```

---

## 💻 Consola Interactiva del World Server (`mangosd`)

Puedes enviar comandos directamente a la consola de `mangosd`:

```powershell
docker attach turtlewow-worldserver
```

Una vez dentro, podrás teclear comandos directamente (ej. `server info`, `account create user pass`).

> [!IMPORTANT]
> **Para salir de la consola sin apagar el servidor:**
> Presiona `CTRL + P` seguido de `CTRL + Q`.

---

## 🔨 Desarrollo C++ y Recompilación Incremental Rápida

Cuando realices modificaciones en el código C++ en `twow-1172/src`:

```powershell
# Recompilar en segundos utilizando ccache
docker compose --profile dev run --rm builder

# Reiniciar los servidores para aplicar los nuevos binarios
docker compose restart authserver worldserver
```

---

## 🗄️ Conexión a la Base de Datos desde Windows

Puedes conectarte desde cualquier gestor MySQL (Navicat, DBeaver, HeidiSQL, DataGrip):

* **Host:** `127.0.0.1`
* **Puerto:** `3306`
* **Usuario:** `root`
* **Contraseña:** `mangos`

---

## 📋 Monitoreo de Logs

```powershell
# Ver logs en vivo de todos los servicios
docker compose logs -f

# Ver logs en vivo del World Server
docker compose logs -f worldserver

# Ver logs del Auth Server
docker compose logs -f authserver
```

---

## 🛑 Detener o Reiniciar el Servidor

```powershell
# Detener contenedores sin borrar datos
docker compose down

# Reiniciar contenedores
docker compose restart

# Destruir volúmenes y reiniciar la base de datos limpia desde cero
docker compose down -v
docker compose up -d
```
