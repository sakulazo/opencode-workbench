---
name: deploy
description: Deploy an application on the VPS. Clones the repository, configures Docker Compose, Nginx and SSL.
type: command
version: 1.0
status: stable
purpose: Automate the deployment of a web application on a VPS: clone, Docker Compose, reverse proxy and SSL certificate.
tags: [deploy, docker, nginx, ssl, vps]
agent: vps-manager
---

# Desplegar Aplicacion

Voy a desplegar la siguiente aplicacion en el VPS.

## Informacion del despliegue

- **Dominio**: $1
- **Repositorio**: $2
- **Puerto interno**: $3 (default: 3000)

## Pasos a seguir

1. Verificar recursos del sistema disponibles
2. Clonar o actualizar el repositorio en `/opt/<aplicacion>`
3. Configurar variables de entorno en `.env`
4. Crear o actualizar `docker-compose.yml`
5. Construir y levantar contenedores
6. Configurar Nginx como reverse proxy
7. Instalar certificado SSL con Certbot
8. Verificar que la aplicacion esta funcionando
9. Configurar backup automatico si se solicita

## Comandos a ejecutar

```bash
# Verificar estado del sistema
free -h && df -h && uptime

# Clonar repositorio
cd /opt && sudo git clone $2 && cd $(basename $2 .git)

# Configurar Docker
sudo docker compose up -d --build

# Configurar Nginx
# (configuracion basada en el dominio proporcionado)

# Obtener SSL
sudo certbot --nginx -d $1 -d www.$1
```

Ejecuta estos pasos de forma secuencial, verificando cada uno antes de continuar.
