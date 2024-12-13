#!/bin/ash
set -e

echo "Checking ${SHINYPROXY_APPLICATION_DIR} for Shinyproxy config file either as application.tmp or as application.yml"

# substitute ${ENV_VARIABLE}s in application.tmp with container environment variables
if [ -f ${SHINYPROXY_APPLICATION_DIR}/application.tmp ]; then
    echo "  - found application.tmp; plugging in environment variables to application.yml"
    envsubst < ${SHINYPROXY_APPLICATION_DIR}/application.tmp > /opt/shinyproxy/application.yml
fi

# If file ${SHINYPROXY_APPLICATION_DIR}/application.yml is available, make the shinyproxy configuration available to the application
if [ -f ${SHINYPROXY_APPLICATION_DIR}/application.yml ]; then
    #rm --force ${SHINYPROXY_INSTALL_DIR}/application.yml
    cp --force ${SHINYPROXY_APPLICATION_DIR}/application.yml /opt/shinyproxy/application.yml
    echo "  - copying ${SHINYPROXY_APPLICATION_DIR}/application.yml to /opt/shinyproxy/application.yml in Shinyproxy container"
else
    echo "No 'application.yml' or 'application.tmp' was found: defaulting to demo Shinyproxy configuration"
fi

# If there is an apps folder in the SHINYPROXY_INSTALL_DIR, copy the files over (for development purposes)
if [ -d ${SHINYPROXY_APPLICATION_DIR}/apps ]; then
    echo "  - moving all apps from ${SHINYPROXY_APPLICATION_DIR}/apps to ${SHINYPROXY_INSTALL_DIR} in Shinyproxy container"
    cp --force --recursive ${SHINYPROXY_APPLICATION_DIR}/apps /opt/shinyproxy/blackbar
    chown -R shinyproxy:blackbar /opt/shinyproxy/blackbar/apps/
else
    echo "Note: no 'apps' folder at ${SHINYPROXY_APPLICATION_DIR}"
fi

cat /opt/shinyproxy/application.yml
echo "\nStarting up Shinyproxy\n"

exec "$@"