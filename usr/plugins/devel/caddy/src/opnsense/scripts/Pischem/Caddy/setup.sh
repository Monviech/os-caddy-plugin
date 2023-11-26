#!/bin/sh

# Define directories
CADDY_DIR="/usr/local/etc/caddy"
CADDY_ACME_DIR="${CADDY_DIR}/acme"
CADDY_LOCK_DIR="${CADDY_DIR}/lock"
CADDY_LOG_DIR="/var/log/caddy"

# Create Caddy configuration directories with appropriate permissions
mkdir -p "${CADDY_DIR}"
mkdir -p "${CADDY_ACME_DIR}"
mkdir -p "${CADDY_LOCK_DIR}"

# Set permissions for Caddy configuration directories
chown -R root:wheel "${CADDY_DIR}"
chmod -R 750 "${CADDY_DIR}"

# Create Caddy log directory
mkdir -p "${CADDY_LOG_DIR}"

# Set permissions for Caddy log directory
chown -R root:wheel "${CADDY_LOG_DIR}"
chmod -R 750 "${CADDY_LOG_DIR}"

