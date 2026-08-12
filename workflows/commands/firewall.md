---
name: firewall
description: Configure the UFW firewall on the VPS: list rules, open ports, block IPs, secure SSH setup.
type: command
version: 1.0
status: stable
purpose: Manage the UFW firewall of a VPS: status, rules, ports, IP blocking and hardened configurations.
tags: [firewall, ufw, security, vps]
agent: vps-manager
---

# Firewall (UFW)

Accion de firewall solicitada: $1

## Acciones disponibles

- `status`: Ver estado y reglas actuales
- `allow <puerto>`: Abrir un puerto
- `deny <puerto>`: Bloquear un puerto
- `ssh`: Configurar SSH seguro (solo key-based)
- `hardened`: Configuracion hardened completa
- `log`: Ver logs del firewall
- `reset`: Resetear a configuracion por defecto

## Comandos de firewall

```bash
# Estado
sudo ufw status verbose

# Configuracion basica segura
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Abrir puerto especifico
sudo ufw allow $2/tcp

# Bloquear IP
sudo ufw deny from <ip>

# Reglas avanzadas
sudo ufw allow from 10.0.0.0/8 to any port 5432  # Solo desde red interna

# Habilitar
sudo ufw enable
sudo ufw reload

# Logs
sudo ufw logging on
```

Ejecuta la accion solicitada y verifica que las reglas estan correctas.
