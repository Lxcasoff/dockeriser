# 🐳 TP1 — Blog Fullstack Dockerisé (React, Express, PostgreSQL, WebSocket)

Ce projet est un **TP complet de développement d’une application web fullstack dockerisée**, réalisé dans le cadre du Master Cybersécurité à l’IPSSI.  
L'objectif était de construire un **blog interactif**, connecté à une base de données, avec notifications en temps réel.

---

## 🚀 Technologies utilisées

| Couche      | Stack choisie | Raison du choix |
|-------------|---------------|-----------------|
| Frontend    | React + Bootstrap | Pour la rapidité de développement, la modularité, et un rendu propre sans surcharge de configuration (contrairement à Tailwind) |
| Backend     | Express.js    | Léger, rapide à mettre en place, parfaitement adapté aux API REST |
| Base de données | PostgreSQL | Robuste, open-source, et facilement intégrable avec Docker |
| Communication temps réel | ZeroMQ (WebSocket) | Pour démontrer les capacités de push serveur-frontend |
| Conteneurisation | Docker + Docker Compose | Simplifie le déploiement et la gestion des services |

---

## 📦 Architecture du projet

```
TP1/
├── backend/        # Express.js + PostgreSQL
├── frontend/       # React + Bootstrap (Vite)
├── websocket/      # Serveur WebSocket avec ZeroMQ
├── docker-compose.yml
├── run.sh          # Script d'installation & démarrage
└── README.md
```

---

## 🧩 Fonctionnalités implémentées

- ✅ Affichage dynamique des articles stockés en base PostgreSQL
- ✅ Architecture modulaire côté frontend (Header, BlogCard, Footer)
- ✅ Système de notification WebSocket (ZeroMQ) quand un nouvel article est publié
- ✅ Conteneurisation complète avec Docker Compose
- ✅ Scripts automatisés d’installation et lancement (`run.sh`)

---

## ⚠️ Problèmes rencontrés

- **TailwindCSS :** trop verbeux et peu intuitif → remplacé par Bootstrap pour rapidité et clarté.
- **WebSocket avec ZeroMQ :** compréhension de l’abstraction Publisher/Subscriber nécessaire
- **Conflits Git :** lors de la collaboration (résolu avec `git rebase`)
- **Poids du dépôt :** nécessité d’ajouter `.gitignore` pour exclure les `node_modules` et autres fichiers inutiles

---

## 📸 Résultat

Interface responsive type "cards" avec Bootstrap :
- Affichage élégant des articles
- Mise en page fluide
- Notification toast quand un nouvel article est détecté

---

## 🛠️ Lancer le projet

```bash
# Étapes :
git clone https://github.com/ChuisJu/dockeriser.git
cd TP1
chmod +x run.sh
./run.sh

# Ensuite, accéder à : http://localhost:3000
```

---

## ✒️ Auteurs

- @LXcasoff
- @ChuisJu 
- @AdarLab7410
---

## 🧼 Propreté du code

- `.gitignore` configuré
- Structure modulaire
- Code commenté et clair

---

## 🏁 Prochaines étapes possibles

- Ajout de la création d’articles depuis une interface admin
- Authentification utilisateur (JWT)
- Intégration SonarQube pour l’analyse qualité (déjà prévu)

---