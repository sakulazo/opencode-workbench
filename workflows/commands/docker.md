---
name: docker
description: Manage Docker on the VPS: list, restart, view logs or clean containers and images.
type: command
version: 1.0
status: stable
purpose: Provide a quick interface to common Docker operations on a VPS: listing, logs, lifecycle and cleanup.
tags: [docker, containers, vps]
agent: vps-manager
---

# Gestion Docker

Operacion Docker solicitada: $1

## Operaciones disponibles

- `list` / `ls`: Listar contenedores e imagenes
- `logs <nombre>`: Ver logs de un contenedor
- `restart <nombre>`: Reiniciar un contenedor
- `stop <nombre>`: Detener un contenedor
- `start <nombre>`: Iniciar un contenedor
- `compose up`: Levantar compose
- `compose down`: Bajar compose
- `compose ps`: Estado de compose
- `clean`: Limpiar imagenes y contenedores sin usar
- `stats`: Estadisticas de recursos

## Ejecucion

Basado en la operacion solicitada (`$1`), ejecuta los comandos Docker correspondientes.

```bash
# Listar todo
docker ps -a
docker images
docker volume ls
docker network ls

# Logs
docker logs -f --tail=100 <nombre>

# Stats
docker stats --no-stream

# Limpieza
docker system df
docker system prune -f
docker image prune -a -f
```

Presenta los resultados de forma clara y sugiere acciones si hay problemas.
