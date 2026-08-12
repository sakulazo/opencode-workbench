---
name: vps-status
description: Show the full status of the VPS: resources, services, Docker, SSL and recent logs.
type: command
version: 1.0
status: stable
purpose: Generate a complete health report of a VPS: system resources, critical services, containers, SSL certificates, network, logs and security.
tags: [vps, monitoring, status]
agent: vps-manager
---

# Estado del VPS

Voy a generar un reporte completo del estado del servidor.

## Areas a revisar

1. **Recursos del sistema**: CPU, memoria RAM, disco, carga del sistema
2. **Servicios criticos**: Nginx, Docker, bases de datos, aplicaciones
3. **Contenedores Docker**: Estado de todos los contenedores
4. **Certificados SSL**: Estado y fecha de expiracion
5. **Red**: Conexiones activas, puertos abiertos
6. **Logs recientes**: Errores criticos en la ultima hora
7. **Seguridad**: Intentos de login fallidos, fail2ban

## Comandos de verificacion

```bash
# Recursos
echo "=== SISTEMA ===" && uptime && echo "" && free -h && echo "" && df -h / /var

# Servicios
echo "=== SERVICIOS ===" && systemctl status nginx docker --no-pager 2>/dev/null

# Docker
echo "=== CONTENEDORES ===" && docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# SSL
echo "=== CERTIFICADOS SSL ===" && sudo certbot certificates 2>/dev/null

# Red
echo "=== PUERTOS ===" && sudo ss -tlnp

# Logs
echo "=== ERRORES RECIENTES ===" && sudo journalctl --since "1 hour ago" -p err --no-pager | tail -20
```

Ejecuta todos estos comandos y presenta un resumen claro y organizado del estado del servidor.
