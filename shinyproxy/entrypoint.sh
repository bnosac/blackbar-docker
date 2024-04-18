#!/bin/ash
set -e

echo "Checking ${SHINYPROXY_APPLICATION_DIR} for Shinyproxy config file"

# substitute ${ENV_VARIABLE}s with container environment variables
if [ -f ${SHINYPROXY_APPLICATION_DIR}/application.tmp ]; then
   echo "  - found application.tmp; interpolating to application.yml"
   envsubst < ${SHINYPROXY_APPLICATION_DIR}/application.tmp > ${SHINYPROXY_APPLICATION_DIR}/application.yml
fi

# make the shinyproxy configuration available to the application
if [ -f ${SHINYPROXY_APPLICATION_DIR}/application.yml ]; then
   ln -s ${SHINYPROXY_APPLICATION_DIR}/application.yml ${SHINYPROXY_INSTALL_DIR}/application.yml
   echo "  - created symbolic link from ${SHINYPROXY_APPLICATION_DIR}/application.yml to ${SHINYPROXY_INSTALL_DIR}/application.yml"
else
   echo "No 'application.yml' or 'application.tmp' was found: defaulting to demo configuration"
fi

#cd ${SHINYPROXY_INSTALL_DIR}

exec "$@"
