#!/bin/bash

echo "📦 Installation des dépendances backend..."
cd backend && npm install && cd ..

echo "📦 Installation des dépendances frontend..."
cd frontend && npm install && npm run build && cd ..

echo "📦 Installation des dépendances websocket..."
cd websocket && npm install && cd ..

echo "🐳 Lancement de l'infrastructure Docker..."
docker compose up --build
