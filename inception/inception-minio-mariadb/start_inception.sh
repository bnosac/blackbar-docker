#! /bin/bash

###############################################################################################
## If INCEPTION_DB_URL is not filled in and INCEPTION_DB_DRIVER = org.mariadb.jdbc.Driver
##  - Connect to the internal MariaDB
## If INCEPTION_DB_URL is not filled in and INCEPTION_DB_DRIVER != org.mariadb.jdbc.Driver
##  - Connect to the internal HyperSQL
## If INCEPTION_DB_URL is filled in connect to the external MariaDB
##
DB_SETUP=default
if [[ -z "$INCEPTION_DB_URL" && "$INCEPTION_DB_DRIVER" == "org.mariadb.jdbc.Driver" ]]; then
DB_SETUP=mariadb_internal
fi
if [[ -n "$INCEPTION_DB_URL" ]]; then
DB_SETUP=db_external
fi

if [[ "$DB_SETUP" == "default" ]]; then
##
## Use internal HyperSQL database
##
echo "\$INCEPTION_DB_URL is empty, Inception will use an HyperSQL database to store it's metadata"
unset INCEPTION_DB_URL
unset INCEPTION_DB_USERNAME
unset INCEPTION_DB_PASSWORD
unset INCEPTION_DB_DIALECT
unset INCEPTION_DB_DRIVER
fi
if [[ "$DB_SETUP" == "mariadb_internal" ]]; then
##
## Use internal MariaDB database
##
echo "\$INCEPTION_DB_URL is empty, Inception will start up a MariaDB to store it's metadata"
INCEPTION_DB_URL="jdbc:mariadb://localhost:3306/inception?useSSL=false&serverTimezone=UTC&useUnicode=true&characterEncoding=UTF-8"
INCEPTION_DB_USERNAME=${INCEPTION_DB_USERNAME}
INCEPTION_DB_PASSWORD=${INCEPTION_DB_PASSWORD}
INCEPTION_DB_DIALECT=org.hibernate.dialect.MariaDB106Dialect
INCEPTION_DB_DRIVER=org.mariadb.jdbc.Driver
fi
echo "------- Inception DB URL ------"
echo $INCEPTION_DB_URL

###############################################################################################
## Defining the Inception properties
##  - encrypt the admin password
##  - define all the other inception properties
##
echo "------- Encrypting Inception admin password ------"
export INCEPTION_PASSWORD=$(htpasswd -bnBC 10 "" $INCEPTION_PASSWORD | tr -d ':\n')

if [ ! -f /export/settings.properties ]; then
echo "------- Defining inception properties file ------"
cat <<EOF >/export/settings.properties
##
## Login settings
##
auth.mode=INCEPTION_AUTHENTICATION
security.default-admin-username=INCEPTION_USERNAME
security.default-admin-password=INCEPTION_PASSWORD
security.default-admin-remote-access=true
remote-api.enabled=true
auth.preauth.header.principal=INCEPTION_PREAUTH_HEADER
auth.preauth.newuser.roles=ROLE_PROJECT_CREATOR
auth.user.INCEPTION_PREAUTH_ADMIN.roles=ROLE_ADMIN
##
## Hosted at /inception
##
server.port=8080
server.servlet.context-path=/inception
sharing.invites.enabled=true
sharing.invites.invite-base-url=INCEPTION_HOST
wicket.core.csrf.enabled=false
##
## Backup
##   - Every 5 minutes
##   - Delete annotation backups older than 30 days (60 * 60 * 24 * 30 = 30 days)
backup.interval=300
backup.keep.time=2592000
backup.keep.number=10
##
## Connection to the database with Inception metadata
##
useSSL=false
allowPublicKeyRetrieval=true
serverTimezone=UTC
##
## UI elements
##
annotation.default-preferences.page-size=2000
websocket.enabled=true
##
## Disable some warnings
##
warnings.embeddedDatabase=true
telemetry.auto-respond=REJECT
##
## Disable CAS doctor on import
##
document-import.run-cas-doctor-on-import=OFF
EOF
sed -i 's|INCEPTION_USERNAME|'"$INCEPTION_USERNAME"'|g' /export/settings.properties
sed -i 's|INCEPTION_PASSWORD|{bcrypt}'"$INCEPTION_PASSWORD"'|g' /export/settings.properties
sed -i 's|INCEPTION_HOST|'"$INCEPTION_HOST"'|g' /export/settings.properties
sed -i 's|INCEPTION_AUTHENTICATION|'"$INCEPTION_AUTHENTICATION"'|g' /export/settings.properties
sed -i 's|INCEPTION_PREAUTH_HEADER|'"$INCEPTION_PREAUTH_HEADER"'|g' /export/settings.properties
sed -i 's|INCEPTION_PREAUTH_ADMIN|'"$INCEPTION_PREAUTH_ADMIN"'|g' /export/settings.properties
else 
echo "------- Existing inception properties file ------"
fi
cat /export/settings.properties

###############################################################################################
## Launch Inception
##
echo "------- Launching Inception ------"
java "-Xmx750m" -Djava.awt.headless=true -Dinception.home=/export -jar /opt/inception/inception-app-standalone.jar