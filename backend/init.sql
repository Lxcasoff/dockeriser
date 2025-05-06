CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO posts (title, content, image_url) VALUES
(
  'Comment Docker change la donne pour les devs',
  'Découvrez pourquoi Docker est devenu un outil incontournable...',
  '/images/docker-article.jpg'
),
(
  'PostgreSQL : astuces de performance',
  'Voici 5 astuces pratiques pour optimiser vos requêtes SQL...',
  '/images/postgres-performance.jpg'
),
(
  'Pourquoi adopter une stack React + Vite',
  'On décortique pourquoi cette stack séduit les développeurs...',
  '/images/react-vite.jpg'
);
