---
name: ssl
description: Configure or renew SSL certificates with Certbot for a domain on the VPS.
type: command
version: 1.0
status: stable
purpose: Manage SSL/TLS certificates with Certbot on a VPS: status, obtain, renew, test and inspect.
tags: [ssl, certbot, tls, vps]
agent: vps-manager
---

# Gestion SSL/TLS

Accion SSL solicitada para el dominio: $1

## Acciones disponibles

- `status`: Ver estado de certificados existentes
- `obtain`: Obtener nuevo certificado
- `renew`: Renovar certificados
- `test`: Probar renovacion (dry-run)
- `info`: Informacion detallada de un certificado

## Proceso de configuracion SSL

```bash
# Estado actual
sudo certbot certificates

# Obtener nuevo certificado
sudo certbot --nginx -d $1 -d www.$1

# Probar renovacion
sudo certbot renew --dry-run

# Forzar renovacion
sudo certbot renew --force-renewal

# Verificar fecha de expiracion
sudo certbot certificates | grep -A2 "$1"
```

Ejecuta la accion solicitada y verifica que el certificado esta correctamente configurado en Nginx.
