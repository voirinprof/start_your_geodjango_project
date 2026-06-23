# GeoBusiness — Premier projet GeoDjango

Bienvenue dans ce projet d'introduction à **GeoDjango** et **PostGIS**. Ce guide vous accompagne pas à pas pour mettre en place votre environnement de développement et comprendre la structure du projet.

## Objectif du projet

Ce projet est une introduction pratique à la création d'applications web géospatiales avec :
- **Django** — le framework web Python
- **GeoDjango** — l'extension géospatiale de Django
- **PostGIS** — l'extension géospatiale de PostgreSQL
- **Docker** — pour un environnement de développement identique pour tout le monde

À la fin, vous saurez stocker des données géographiques (points, polygones) dans une base de données, les manipuler dans l'admin Django, et écrire des requêtes spatiales (distance, proximité, intersection).

## Prérequis

Avant de commencer, installez sur ta machine :

1. **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (Windows/Mac) ou Docker + Docker Compose (Linux)
2. **[VS Code](https://code.visualstudio.com/)**
3. **Git**

Vous n'avez **pas besoin** d'installer Python, PostgreSQL, ou GDAL sur votre machine (Tout tourne dans des conteneurs Docker). 

## Démarrage rapide

### 1. Cloner le repo

```bash
git clone <url-du-repo>
cd start_your_geodjango_project
```
Ajustez le répertoire en fonction de votre machine.

### 2. Créer ton fichier `.env`

Le fichier `.env` contient des informations de configuration (mots de passe, noms de base de données) qui ne doivent **jamais** être partagées publiquement sur GitHub. C'est pourquoi on vous fournit un modèle à copier :

```bash
cp .env.example .env
```

Vous pouvez laisser les valeurs par défaut pour ce projet d'apprentissage.

### 3. Lancer les conteneurs

```bash
docker compose up -d --build
```

Cette commande va :
- Télécharger l'image PostGIS (base de données géospatiale)
- Construire l'image de l'application (Python + GDAL + Django)
- Démarrer les deux conteneurs en arrière-plan

La première fois, ça peut prendre quelques minutes (téléchargement + compilation). Les fois suivantes seront beaucoup plus rapides.

### 4. Vérifier que tout tourne

```bash
docker compose ps
```

Vous devriez voir deux services avec le statut `running` (ou `healthy` pour la base de données) :
- `geobusiness_db`
- `geobusiness_app`

### 5. Ouvrir le projet dans VS Code

1. Ouvre le dossier `geobusiness` dans VS Code

### 6. Appliquer les migrations (créer les tables en base)

Dans le terminal VS Code (à l'intérieur du conteneur, ou via `docker compose exec`) :

```bash
python manage.py migrate
```

### 7. Créer ton compte administrateur

```bash
python manage.py createsuperuser
```

Suivez les instructions (nom d'utilisateur, email, mot de passe).

### 8. Lancer le serveur de développement

```bash
python manage.py runserver 0.0.0.0:8000
```

### 9. Ouvrir l'application

Va sur [http://localhost:8000/admin/](http://localhost:8000/admin/) et connectez-vous avec le compte créé à l'étape 7.

Vous devriez voir l'interface d'administration Django, avec l'app **Place** listée. Clique sur **Place** → **Ajouter** pour voir la carte interactive et créer ton premier lieu géolocalisé !

## Structure du projet

```
start_your_geodjango_project/
├── geobusiness/             # Configuration du projet Django (settings, urls)
├── place/                   # Notre application : gestion de lieux géolocalisés
│   ├── models.py             # Définition du modèle Place (avec un champ géographique)
│   ├── admin.py              # Configuration de l'admin (carte interactive)
│   └── migrations/           # Historique des changements de la base de données
├── docker-compose.yml       # Définition des services (app + base de données)
├── Dockerfile                # Recette de construction de l'image de l'app
├── requirements.txt          # Dépendances Python
├── .env.example               # Modèle de configuration (à copier en .env)
└── manage.py                  # Point d'entrée des commandes Django
```

## Le modèle `Place`

Le cœur de ce projet est le modèle `Place`, défini dans `place/models.py` :

```python
class Place(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    location = models.PointField(geography=True, srid=4326)
    created_at = models.DateTimeField(auto_now_add=True)
```

Le champ important est `location` : c'est un `PointField`, un type de donnée géospatial qui stocke des coordonnées (longitude, latitude). Le paramètre `srid=4326` indique qu'on utilise le système de coordonnées GPS standard (WGS84) — celui utilisé par Google Maps, ton téléphone, etc.

## Commandes utiles au quotidien

| Commande | Effet |
|---|---|
| `docker compose up -d` | Démarrer les conteneurs |
| `docker compose down` | Arrêter les conteneurs |
| `docker compose logs -f app` | Voir les logs de l'application en direct |
| `docker compose exec app python manage.py <commande>` | Exécuter une commande Django depuis l'hôte (sans être attaché au conteneur) |
| `python manage.py makemigrations` | Créer les fichiers de migration après un changement de modèle |
| `python manage.py migrate` | Appliquer les migrations à la base de données |
| `python manage.py shell` | Ouvrir un shell Python interactif avec Django chargé |

## Problèmes fréquents

**Le serveur ne se recharge pas après une modification**
Vérifiez que `python manage.py runserver` est toujours en train de tourner dans un terminal. Il surveille les fichiers `.py` et redémarrez automatiquement — regardez s'il y a un message d'erreur dans le terminal qui l'aurait fait planter.

**`Permission denied` en essayant de modifier un fichier**
Si vous avez créé des fichiers via `docker compose exec` plutôt que via VS Code, ils peuvent appartenir à `root`. Demandez de l'aide en cours, ou consultez la section permissions dans les notes du cours.

**`ModuleNotFoundError` après avoir changé de branche Git**
Quelqu'un a peut-être ajouté une dépendance dans `requirements.txt`. Reconstruisez l'image :
```bash
docker compose build app
docker compose up -d
```

**La page admin affiche une erreur 500 ou ne charge pas la carte**
Vérifiez dans la console du navigateur (`F12`) s'il y a une erreur de chargement de script — ça arrive parfois si la connexion internet est coupée (la carte de l'admin Django charge des tuiles depuis OpenStreetMap).

## Pour aller plus loin

- [Documentation officielle GeoDjango](https://docs.djangoproject.com/en/stable/ref/contrib/gis/)
- [Documentation PostGIS](https://postgis.net/documentation/)
- [Tutoriel GeoDjango officiel](https://docs.djangoproject.com/en/stable/ref/contrib/gis/tutorial/)

---

💬 Une question, un blocage ? N'hésite pas à demander en classe ou sur le forum du cours plutôt que de rester bloqué seul plus de 15-20 minutes.
