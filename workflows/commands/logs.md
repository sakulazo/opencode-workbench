---
name: logs
description: Monitor system, Nginx, Docker or application logs on the VPS in real time.
type: command
version: 1.0
status: stable
purpose: Provide a quick interface to monitor logs on a VPS: system, Nginx, Docker, applications, errors and security.
tags: [logs, monitoring, vps]
agent: vps-manager
---

# Monitoreo de Logs

Tipo de logs a monitorear: $1

## Tipos de logs

- `system`: Logs del sistema (syslog, auth, kern)
- `nginx`: Logs de Nginx (access y error)
- `docker <nombre>`: Logs de un contenedor Docker
- `app <nombre>`: Logs de una aplicacion especifica
- `errors`: Errores criticos recientes
- `security`: Logs de seguridad (auth, fail2ban)
- `all`: Todos los logs importantes

## Comandos de monitoreo

```bash
# Sistema
sudo tail -f /var/log/syslog
sudo tail -f /var/log/auth.log
sudo journalctl -f

# Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Docker
docker logs -f --tail=100 <contenedor>
docker compose logs -f --tail=100

# Errores recientes
sudo journalctl --since "1 hour ago" -p err --no-pager

# Seguridad
sudo fail2ban-client status
sudo tail -f /var/log/fail2ban.log
sudo grep "Failed password" /var/log/auth.log | tail -20

# Buscar errores especificos
sudo journalctl -u <servicio> --since "1 hour ago" | grep -i error
```

Monitorea el tipo de logs solicitado y reporta cualquier problema detectado.
