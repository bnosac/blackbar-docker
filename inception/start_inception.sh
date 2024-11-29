#! /bin/bash

echo "------- Environment variables / Password encryption ------"
#env
export INCEPTION_PASSWORD=$(htpasswd -bnBC 10 "" $INCEPTION_PASSWORD | tr -d ':\n')
echo $INCEPTION_PASSWORD;

echo "------- Defining inception properties ------"
cat << \EOF | tee /export/settings.properties
##
## Login of admin
##
#security.default-admin-username=INCEPTION_USERNAME
#security.default-admin-password=INCEPTION_PASSWORD
security.default-admin-remote-access=true
remote-api.enabled=true
##
## Hosted at /inception
##
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
telemetry.auto-respond=REJECT
warnings.embeddedDatabase=false
EOF
#sed -i 's/INCEPTION_USERNAME/'"$INCEPTION_USERNAME"'/g' /export/settings.properties
#sed -i 's/INCEPTION_PASSWORD/{bcrypt}'"$INCEPTION_PASSWORD"'/g' /export/settings.properties
sed -i 's/INCEPTION_HOST/'"$INCEPTION_HOST"'/g' /export/settings.properties
cat /export/settings.properties

echo "------- Launching Inception ------"
java "-Xmx750m" -Djava.awt.headless=true -Dinception.home=/export -jar inception-app-standalone.jar
