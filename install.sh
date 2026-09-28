#!/usr/bin/env bash
if [[ -f .installed ]]; then
    echo "Already installed. Remove .installed to run again."
    exit 0
fi

# .env contains ONLY JWT_SECRET, so overwriting the whole file is safe.
# If you add other variables here, switch to sed to avoid wiping them.
if [[ ! -s ".env" ]] || grep -qx 'JWT_SECRET=' .env; then  # check if the file exists
    printf 'JWT_SECRET=%s\n' "$(openssl rand -hex 128)" > .env  # if .env doesn't exist it's created with the secret
    chmod 400 .env  # owner read-only
else
    echo "Would you overwrite JWT_SECRET? [y/n]"
    read -r answer
    if [[ "$answer" == "y" ]]; then
        NEW_SECRET="$(openssl rand -hex 128)"
        chmod 600 .env
        sed -i "s|^JWT_SECRET=.*$|JWT_SECRET=${NEW_SECRET}|" .env
        chmod 400 .env
        echo "JWT_SECRET overwritten."
    else
        echo "JWT_SECRET not overwritten."
    fi
fi

touch .installed

# start the containers
docker compose pull
docker compose up -d
