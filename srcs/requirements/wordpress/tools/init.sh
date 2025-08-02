#!/bin/bash

set -e

cd /var/www/wordpress

# Droits et permissions
chown -R wordpress:wordpress /var/www
chmod -R 775 /var/www

# Attendre que la base de données soit prête
echo "Attente de la base de données..."
until mysql -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" -e "SELECT 1" 2>/dev/null; do
  echo "MariaDB n'est pas encore disponible...nouvelle tentative dans 1 seconde"
  sleep 1
done
echo "MariaDB est prêt"

# Télécharger WordPress s'il n'est pas là
if [ ! -f "wp-load.php" ]; then
  echo "Téléchargement de WordPress..."
  wp core download --allow-root
fi

# Créer wp-config.php s'il n'existe pas
if [ ! -f "wp-config.php" ]; then
  echo "Création du fichier wp-config.php..."
  wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --allow-root
fi

# Installer WordPress s'il n'est pas installé
if ! wp core is-installed --allow-root; then
  echo "Installation de WordPress..."

  wp core install \
    --url="$WORDPRESS_URL" \
    --title="Inception" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  echo "WordPress installé avec succès"
else
  echo "WordPress est déjà installé"
fi

# Créer un utilisateur contributeur si les variables sont définies
if [ ! -z "$WORDPRESS_USER" ] && [ ! -z "$WORDPRESS_PASSWORD" ] && [ ! -z "$WORDPRESS_EMAIL" ]; then
  if ! wp user get "$WORDPRESS_USER" --allow-root >/dev/null 2>&1; then
    wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" \
      --role=contributor \
      --user_pass="$WORDPRESS_PASSWORD" \
      --allow-root
    echo "Utilisateur $WORDPRESS_USER créé avec succès"
  fi
fi

# Configurer la modération des commentaires
wp option update comment_moderation 1 --allow-root

# Permissions finales
chown -R wordpress:wordpress /var/www/wordpress

# Lancer PHP-FPM
echo "Démarrage de PHP-FPM..."
exec php-fpm7.4 -F
