# API de Cartes HxH

API avec Laravel qui retourne des cartes Hxh au format JSON.

## Installation

```bash
# Démarrer l'application
docker-compose up -d

# Installer les dépendances
docker-compose exec app composer install

# Configurer la base de données
docker-compose exec app php artisan migrate
```

## Utilisation

API : http://localhost:8080/api/cards

Pour tester :
```bash
curl http://localhost:8080/api/cards
```