#!/bin/sh
set -e

# JWT_ENABLED is pasted raw into the JSON below, so anything but true/false
# (e.g. "True" from Ansible) makes NODE_CONFIG invalid and node-config falls
# back to default.json with JWT off. Accept the usual spellings, case-
# insensitively and with surrounding whitespace ignored, and refuse to start
# on anything else rather than guess.
_jwt=$JWT_ENABLED
_jwt=${_jwt#"${_jwt%%[![:space:]]*}"}
_jwt=${_jwt%"${_jwt##*[![:space:]]}"}
case "$_jwt" in
  "") JWT_ENABLED= ;;
  [Tt][Rr][Uu][Ee]|[Yy][Ee][Ss]|[Yy]|[Oo][Nn]|1)     JWT_ENABLED=true ;;
  [Ff][Aa][Ll][Ss][Ee]|[Nn][Oo]|[Nn]|[Oo][Ff][Ff]|0) JWT_ENABLED=false ;;
  *)
    echo "ERROR: JWT_ENABLED='$_jwt' is not a recognized boolean (use true or false). Refusing to start rather than guess." >&2
    exit 1
    ;;
esac

export NODE_CONFIG='{
	"server": {
		"siteUrl": "'${DS_URL:-"/"}'",
		"exampleUrl": "'${EXAMPLE_URL:-http://localhost/example/}'",
		"token": {
			"enable": '${JWT_ENABLED:-false}',
			"secret": "'${JWT_SECRET:-euro-office-dev-jwt-secret-key-2026}'",
			"authorizationHeader": "'${JWT_HEADER:-Authorization}'"
		}
	}
}'
exec "$@"
