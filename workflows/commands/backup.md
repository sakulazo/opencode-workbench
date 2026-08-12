---
name: backup
description: Run backups of databases, files or full server configuration, and manage existing backups (list, restore, verify).
type: command
version: 1.0
status: stable
purpose: Automate server backups: databases, files and configuration, including listing, restore and integrity verification.
tags: [backup, database, vps]
agent: vps-manager
---

# Backup

Tipo de backup solicitado: $1

## Tipos de backup

- `db <nombre>`: Backup de base de datos especifica
- `full`: Backup completo del sistema (DB + archivos + configs)
- `config`: Solo configuraciones (Nginx, systemd, cron, etc.)
- `list`: Listar backups existentes
- `restore <archivo>`: Restaurar desde backup
- `verify`: Verificar integridad de backups

## Directorios de backup

- Base de datos: `/backups/database/`
- Archivos: `/backups/files/`
- Configuracion: `/backups/config/`

## Comandos de backup

```bash
# Backup PostgreSQL
docker exec <contenedor-bd> pg_dump -U <usuario> <bd> | gzip > /backups/database/pg_$(date +%Y%m%d).sql.gz

# Backup MySQL
docker exec <contenedor-bd> mysqldump -u <usuario> -p$MYSQL_PASSWORD <bd> | gzip > /backups/database/mysql_$(date +%Y%m%d).sql.gz

# Backup Redis
docker exec <contenedor-redis> redis-cli BGSAVE
docker cp <contenedor-redis>:/data/dump.rdb /backups/database/redis_$(date +%Y%m%d).rdb

# Backup configuraciones
tar -czf /backups/config/nginx_$(date +%Y%m%d).tar.gz /etc/nginx/
tar -czf /backups/config/systemd_$(date +%Y%m%d).tar.gz /etc/systemd/system/

# Backup archivos de la app
tar -czf /backups/files/app_$(date +%Y%m%d).tar.gz /opt/<aplicacion>/data/

# Listar backups
ls -lh /backups/database/ /backups/files/ /backups/config/

# Limpiar backups antiguos (retencion de 30 dias)
find /backups/ -name "*.gz" -mtime +30 -delete
```

Ejecuta el tipo de backup solicitado y reporta el resultado.
