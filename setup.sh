#!/bin/bash
set -e

# Create acme.json with correct permissions (Traefik requires 600)
touch data/acme.json
chmod 600 data/acme.json

# Generate .env if missing
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Filling secrets automatically..."
  sed -i "s/^AUTHELIA_JWT_SECRET=$/AUTHELIA_JWT_SECRET=$(openssl rand -hex 32)/" .env
  sed -i "s/^AUTHELIA_SESSION_SECRET=$/AUTHELIA_SESSION_SECRET=$(openssl rand -hex 32)/" .env
  sed -i "s/^AUTHELIA_STORAGE_ENCRYPTION_KEY=$/AUTHELIA_STORAGE_ENCRYPTION_KEY=$(openssl rand -hex 32)/" .env
  sed -i "s/^LLDAP_JWT_SECRET=$/LLDAP_JWT_SECRET=$(openssl rand -hex 32)/" .env
  echo ""
  echo "Set LLDAP_ADMIN_PASS in .env, then run: docker compose up -d"
else
  echo ".env already exists, skipping"
fi

echo ""
echo "Also set your email in config/traefik/traefik.yml (acme.email)"
