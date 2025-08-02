# 🚀 Projet Docker WordPress Inception

## 📁 Structure du projet
```
inception/
├── Makefile
├── .env
├── README.md
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── default
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── wordpress.conf
        │   └── tools/
        │       └── init.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            │   └── 50-server.conf
            └── tools/
                └── init.sh
```

## 🛠️ Instructions d'utilisation

### 1. Préparation de l'environnement
```bash
# Ajouter le domaine au fichier hosts
sudo echo "127.0.0.1 wzeraig.42.fr" >> /etc/hosts

# Se placer dans le dossier du projet
cd /home/wzeraig/Documents/42/inception/
```

### 2. Lancement du projet
```bash
# Lancer tout le projet
make all

# Ou en étapes séparées :
make prepare  # Crée les dossiers de données
make build    # Construit les images
```

### 3. Accès au site
- **Site web** : https://wzeraig.42.fr
- **Administration WordPress** : https://wzeraig.42.fr/wp-admin

### 4. Comptes utilisateurs
- **Admin** : Ara / 1234567890
- **Contributeur** : correcteur / correcteur

### 5. Commandes utiles
```bash
# Arrêter les conteneurs
make down

# Tout supprimer (conteneurs, volumes, données)
make purge

# Voir les conteneurs en cours
docker ps

# Accéder à la base MariaDB
docker exec -it mariadb mysql -u wzeraig -p
```

### 6. Accès à la base de données
```bash
# Se connecter à MariaDB
docker exec -it mariadb mysql -u wzeraig -p
# Mot de passe : 123456789

# Une fois connecté :
USE wordpress;
SHOW TABLES;
SELECT user_login FROM wp_users;
```

## 🎯 Points clés pour l'évaluation

1. **Docker Network** : Les conteneurs communiquent via le réseau `inception`
2. **Volumes bind** : Données persistantes dans `/home/wzeraig/data/`
3. **SSL/TLS** : Certificat auto-signé pour HTTPS (port 443 uniquement)
4. **Modération** : Commentaires soumis à validation admin
5. **Rôles** : Admin (Ara) et Contributeur (correcteur)
6. **Images custom** : Toutes les images sont construites à partir de Dockerfile
7. **Base stable** : Debian Bullseye utilisé partout

## ⚠️ Important pour l'évaluation

- Le site doit être accessible uniquement en HTTPS (port 443)
- Aucun accès HTTP (port 80) ne doit fonctionner
- Les données persistent après un redémarrage de la VM
- WordPress est préconfigé (pas de page d'installation)
- Tous les services utilisent des images custom (pas de DockerHub)
