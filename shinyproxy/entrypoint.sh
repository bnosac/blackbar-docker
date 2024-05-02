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
    #rm --force ${SHINYPROXY_INSTALL_DIR}/application.yml
    cp --force ${SHINYPROXY_APPLICATION_DIR}/application.yml ${SHINYPROXY_INSTALL_DIR}/application.yml
    echo "  - copying ${SHINYPROXY_APPLICATION_DIR}/application.yml to ${SHINYPROXY_INSTALL_DIR}/application.yml in Shinyproxy container"
else
    echo "No 'application.yml' or 'application.tmp' was found: defaulting to demo Shinyproxy configuration"
fi

# copy folder with apps to SHINYPROXY_INSTALL_DIR
if [ -d ${SHINYPROXY_APPLICATION_DIR}/apps ]; then
    echo "  - moving all apps from ${SHINYPROXY_APPLICATION_DIR}/apps to ${SHINYPROXY_INSTALL_DIR} in Shinyproxy container"
    cp --force --recursive ${SHINYPROXY_APPLICATION_DIR}/apps /opt/shinyproxy/blackbar
    chown -R shinyproxy:blackbar /opt/shinyproxy/blackbar/apps/
else
    echo "No 'apps' folder at ${SHINYPROXY_APPLICATION_DIR}"
fi

echo "Starting up Shinyproxy"

exec "$@"
