# Inception — WordPress stack on Docker (Nginx TLS, MariaDB)

Infrastructure Docker Compose déployant une stack WordPress **accessible uniquement en HTTPS** via un reverse proxy **Nginx + TLS**, avec base **MariaDB** et persistance des données via volumes.

> Projet École 42 — focus : conteneurisation, réseau Docker, persistance, et configuration TLS.

---

## Architecture (services)

- **nginx** : reverse proxy, terminaison TLS (port **443** uniquement)
- **wordpress** : PHP-FPM + configuration WordPress
- **mariadb** : base de données (réseau privé Docker)

Communication inter-services via un réseau Docker dédié (ex: `inception`).

---

## Structure du projet

```text
inception/
├── Makefile
├── .env                  # variables d’environnement (NE PAS versionner avec secrets)
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

---

## Prérequis

- Linux
- Docker + Docker Compose
- `make`

---

## Installation & Run

### 1) Ajouter le domaine local (si nécessaire)

> Exemple : `wzeraig.42.fr` (adapter au domaine défini dans `.env`)

```bash
echo "127.0.0.1 wzeraig.42.fr" | sudo tee -a /etc/hosts
```

### 2) Lancer la stack

```bash
make all
# ou
make prepare   # crée les dossiers de données
make build     # build les images
# puis docker compose up (selon ton Makefile)
```

### 3) Accéder au site

- Site : `https://wzeraig.42.fr`
- Admin WP : `https://wzeraig.42.fr/wp-admin`

> Les identifiants/mots de passe sont définis via variables d’environnement (`.env`) / scripts d’init.
> ⚠️ Évite de commiter des mots de passe en clair dans le dépôt public.

---

## Commandes utiles

```bash
make down      # stop
make purge     # supprime conteneurs/volumes/données (selon Makefile)

docker ps
```

Accès MariaDB :

```bash
docker exec -it mariadb mysql -u <db_user> -p
```

---

## Sécurité / points d’attention

- **HTTPS uniquement** : exposition volontairement limitée au port **443** ; pas d’accès HTTP (80).
- **TLS** : certificat auto-signé (usage pédagogique/local).
- **Isolation réseau** : services interconnectés via un réseau Docker dédié.
- **Secrets** : mots de passe via `.env` (non versionné) / variables CI.

---

## Conformité projet 42 (rappels)

- Images **custom** (Dockerfile), pas d’images “prêtes à l’emploi” type DockerHub pour les services.
- Persistance via volumes / bind mount (ex: `/home/<user>/data/`).
- Base Debian Bullseye (selon consigne du projet).
