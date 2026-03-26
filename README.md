# CyberCampus

CyberCampus est une application web éducative développée en Swift dans le cadre du projet final du cours d’iOS / Swift.  
Son objectif est de sensibiliser les utilisateurs aux risques numériques et de leur proposer des conseils simples pour mieux se protéger en ligne.

## Objectif du projet

Le projet consiste à créer une application web CRUD en Swift avec :

- Swift 6.2
- Hummingbird 2
- SQLite
- GitHub Codespaces

L’application permet de gérer des fiches de sensibilisation en cybersécurité.

## Fonctionnalités

CyberCampus permet de :

- Ajouter une nouvelle fiche
- Afficher toutes les fiches
- Consulter le détail d’une fiche
- Modifier une fiche existante
- Supprimer une fiche
- Rechercher une fiche par titre
- Filtrer les fiches par niveau de risque

## Structure des données

Chaque fiche est représentée par la structure `CyberGuide` avec les champs suivants :

- `id` : identifiant unique auto-incrémenté
- `title` : titre de la fiche
- `category` : catégorie
- `riskLevel` : niveau de risque (`Faible`, `Moyen`, `Élevé`)
- `description` : description du risque
- `protectionTip` : conseil de protection
- `createdAt` : date de création

## Structure du projet

Le projet est organisé en plusieurs fichiers :

- `Sources/App/Models.swift` : définition de la structure `CyberGuide`
- `Sources/App/Database.swift` : gestion de la base SQLite et opérations CRUD
- `Sources/App/Views.swift` : génération des pages HTML
- `Sources/App/main.swift` : définition des routes et lancement du serveur

## Routes principales

L’application contient les routes suivantes :

- `GET /` : affiche la page d’accueil et la liste des fiches
- `GET /guide/:id` : affiche le détail d’une fiche
- `POST /create` : ajoute une nouvelle fiche
- `POST /update/:id` : met à jour une fiche
- `POST /delete/:id` : supprime une fiche

## Ouverture dans GitHub Codespaces  
  
1. Aller dans **votre dépôt GitHub**.  
2. Cliquer sur le bouton vert **"Code"**.  
3. Ouvrir l’onglet **"Codespaces"**.  
4. Cliquer sur **"Create codespace on main"**.  
5. Attendre que l’environnement se charge.  
  
Lors du premier lancement, Codespaces prépare automatiquement l’environnement Swift, installe les dépendances et configure le projet.  
  
Une fois l’espace prêt, VS Code s’ouvre directement dans le navigateur.

## Lancement du projet

### 1. Compiler le projet

```bash
./build.sh
```

### 2. Lancer le serveur

```bash
./run.sh
```

### 3. Ouvrir l’application
Dans GitHub Codespaces, ouvrir l’onglet Ports puis accéder au port 8080.

## Auteur 
Projet réalisé par Brenda de Oliveira dos Santos