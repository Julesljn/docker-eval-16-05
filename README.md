# API de Cartes

API simple qui retourne des cartes au format JSON.

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


## Commandes utiles

```bash
# Arrêter l'application
docker-compose down

# Voir les logs
docker-compose logs -f

# Redémarrer l'application
docker-compose restart
``` 