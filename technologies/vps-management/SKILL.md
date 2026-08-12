---
name: vps-management
description: Use when managing a VPS server, deploying applications, configuring Docker, managing services, SSL certificates, databases, backups, or monitoring server health. Covers Nginx, systemd, Docker Compose, PostgreSQL, MySQL, Redis, Certbot, UFW, and general Linux server administration.
type: skill
version: 1.0
status: stable
purpose: Provide workflows and best practices for managing Virtual Private Servers and deploying applications.
tags: [vps, linux, docker, nginx, systemd, certbot, ufw, server]
license: MIT
---

# VPS Management Skill

This skill provides workflows and best practices for managing Virtual Private Servers and deploying applications.

## Quick Reference: Common Workflows

### Deploy a Web Application

```bash
# 1. Check system resources
free -h && df -h && uptime

# 2. Clone or pull code
cd /opt && git clone <repo-url> && cd <project>

# 3. Setup with Docker Compose
docker compose up -d --build

# 4. Configure reverse proxy (Nginx)
# Create /etc/nginx/sites-available/<domain>

# 5. Enable SSL
certbot --nginx -d <domain> -d www.<domain>

# 6. Verify
curl -I https://<domain>
```

### Docker Compose Template

```yaml
version: '3.8'

services:
  app:
    build: .
    container_name: myapp
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    volumes:
      - ./data:/app/data
    networks:
      - app-network

  db:
    image: postgres:16-alpine
    container_name: myapp-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backups/db:/backups
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    container_name: myapp-redis
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - app-network

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

### Nginx Reverse Proxy Template

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    # Redirect to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    # SSL (managed by Certbot)
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # SSL hardening
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location /static/ {
        alias /opt/app/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

### Systemd Service Template

```ini
[Unit]
Description=My Application
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/myapp/data

# Environment
EnvironmentFile=/opt/myapp/.env

[Install]
WantedBy=multi-user.target
```

### Database Backup Script

```bash
#!/bin/bash
# /opt/scripts/backup-db.sh

BACKUP_DIR="/backups/database"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# PostgreSQL backup
docker exec myapp-db pg_dump -U user mydb | gzip > "$BACKUP_DIR/pg_mydb_$DATE.sql.gz"

# MySQL backup (alternative)
# docker exec myapp-db mysqldump -u user -p$MYSQL_PASSWORD mydb | gzip > "$BACKUP_DIR/mysql_mydb_$DATE.sql.gz"

# Redis backup
docker exec myapp-redis redis-cli BGSAVE
docker cp myapp-redis:/data/dump.rdb "$BACKUP_DIR/redis_$DATE.rdb"

# Cleanup old backups
find "$BACKUP_DIR" -name "*.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR" -name "*.rdb" -mtime +$RETENTION_DAYS -delete

# Optional: upload to S3
# aws s3 sync "$BACKUP_DIR" s3://my-backups/db/ --delete
```

### SSL Certificate Management

```bash
# Check certificate expiry
certbot certificates

# Test renewal
certbot renew --dry-run

# Force renewal
certbot renew --force-renewal

# Add domain to existing cert
certbot --nginx -d newdomain.com

# Get standalone cert
certbot certonly --standalone -d example.com
```

### System Health Check Script

```bash
#!/bin/bash
# /opt/scripts/health-check.sh

echo "=== System Health Report ==="
echo "Date: $(date)"
echo ""

echo "--- Uptime ---"
uptime
echo ""

echo "--- Memory ---"
free -h
echo ""

echo "--- Disk ---"
df -h / /var /tmp 2>/dev/null
echo ""

echo "--- CPU Load ---"
cat /proc/loadavg
echo ""

echo "--- Docker Status ---"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "--- Failed Systemd Services ---"
systemctl --failed
echo ""

echo "--- Recent Errors (last hour) ---"
journalctl --since "1 hour ago" -p err --no-pager | tail -20
echo ""

echo "--- SSL Certificates ---"
certbot certificates 2>/dev/null | grep -E "Certificate Name|Expiry Date"
echo ""

echo "--- Network Connections ---"
ss -tlnp | head -20
```

## Security Checklist

Before going to production:

- [ ] SSH key-based authentication enabled
- [ ] Password authentication disabled
- [ ] UFW firewall configured (only ports 22, 80, 443)
- [ ] fail2ban installed and configured
- [ ] Automatic security updates enabled
- [ ] Non-root user for application
- [ ] Database not exposed to public
- [ ] Environment variables not in code
- [ ] Docker containers run as non-root
- [ ] SSL certificates auto-renewal tested
- [ ] Backup schedule configured and tested
- [ ] Monitoring and alerting configured

## Log Locations

| Service | Log Location |
|---------|-------------|
| System | `/var/log/syslog`, `/var/log/auth.log` |
| Nginx | `/var/log/nginx/access.log`, `/var/log/nginx/error.log` |
| Docker | `docker logs <container>` |
| Systemd | `journalctl -u <service>` |
| PostgreSQL | Docker logs or `/var/log/postgresql/` |
| Certbot | `/var/log/letsencrypt/letsencrypt.log` |

## Troubleshooting

### Common Issues

**Port already in use:**
```bash
ss -tlnp | grep :80
sudo lsof -i :80
sudo kill <pid>  # or systemctl stop <service>
```

**Docker permission denied:**
```bash
sudo usermod -aG docker $USER
# Logout and login again
```

**Nginx configuration error:**
```bash
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

**SSL certificate not renewing:**
```bash
sudo certbot renew --dry-run
sudo systemctl status certbot.timer
```

**Disk full:**
```bash
du -sh /* | sort -rh | head -10
docker system df
docker system prune -f
```
