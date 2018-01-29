#!/bin/sh
set -e

# Configuration
APP_DIR="/var/www"

# Backup the prev install in case of fail...
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Backup old limesurvey installation in $(pwd)"
echo "[INFO] ---------------------------------------------------------------"
tar -zcf /var/backup/limesurvey/limesurvey-v$(date '+%Y%m%d%H%M%S').tar.gz $APP_DIR
echo "[INFO] Complete! Backup successfully done in $(pwd)"

# File copy strategy taken from wordpress entrypoint
# @see https://github.com/docker-library/wordpress/blob/master/fpm/docker-entrypoint.sh
# @see https://manual.limesurvey.org/Upgrading_from_a_previous_version/fr#Upgrading_from_version_1.50_or_later_to_any_later_2.xx_version
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Installing or upgrading limesurvey in $(pwd) - copying now..."
echo "[INFO] ---------------------------------------------------------------"
echo "[INFO] Removing old installation..."
if [[ -d "${APP_DIR}/upload" ]]; then
    mv -f $APP_DIR/upload /tmp/limesurvey-upload
fi
find $APP_DIR -maxdepth 1 -mindepth 1 | xargs rm -rf
echo "[INFO] Extracting new installation"
#extension
mv /arrayTextAdapt /usr/src/limesurvey/application/core/plugins
tar cf - --one-file-system -C /usr/src/limesurvey . | tar xf - -C $APP_DIR
if [[ -d "" ]]; then
echo "[INFO] Restoring requested files from prev installation"
    mv -f /tmp/limesurvey-upload $APP_DIR/upload
fi

# Rights fixed
echo "[INFO] Fixing rights"
#mv /arrayTextAdapt /var/www/application/core/plugins
chown -Rf www-data:www-data $APP_DIR

# Done
echo "[INFO] Complete! Limesurvey has been successfully installed / upgraded to $(pwd)"

# Exec main command
exec "$@"
