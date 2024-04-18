#!/bin/ash
set -e

echo "Initialising ShinyProxy configuration..."

cd ${SHINYPROXY_APP_DIR}
echo "  - checking ${PWD} for Shinyproxy config file"

# substitute ${ENV_VARIABLE}s with container environment variables
if [ -f application.tmp ]; then
   echo "  - found application.tmp; interpolating to application.yml"
   envsubst < application.tmp > application.yml
fi

# make the shinyproxy configuration available to the application
if [ -f 'application.yml' ]; then
   ln -s ${PWD}/application.yml ${SHINYPROXY_INSTALL_DIR}/application.yml
   echo "  - created symbolic link from ${PWD}/application.yml to ${SHINYPROXY_INSTALL_DIR}/application.yml"
   echo "Completed ShinyProxy configuration"
else
   echo "No 'application.yml' or 'application.tmp' was found: defaulting to demo configuration"
fi

cd ${SHINYPROXY_INSTALL_DIR}

exec "$@"
