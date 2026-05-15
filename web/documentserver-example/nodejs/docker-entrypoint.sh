#!/bin/sh
set -e
export NODE_CONFIG='{
	"server": {
		"siteUrl": "'${DS_URL:-"/"}'",
		"exampleUrl": "'${EXAMPLE_URL:-http://localhost/example/}'",
		"token": {
			"enable": '${JWT_ENABLED:-false}',
			"secret": "'${JWT_SECRET:-secret}'",
			"authorizationHeader": "'${JWT_HEADER:-Authorization}'"
		}
	}
}'
exec "$@"
