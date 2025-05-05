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
  'Découvrez pourquoi Docker est devenu un outil incontournable pour le développement moderne. On vous montre comment l’utiliser efficacement dans vos projets.',
  'https://via.placeholder.com/400x200?text=Docker'
),
(
  'PostgreSQL : astuces de performance',
  'Voici 5 astuces pratiques pour optimiser vos requêtes SQL et tirer le meilleur de PostgreSQL même sur des bases de données volumineuses.',
  'https://via.placeholder.com/400x200?text=PostgreSQL'
),
(
  'Pourquoi adopter une stack React + Vite',
  'On décortique pourquoi cette stack séduit les développeurs frontend : rapidité, simplicité, et une DX au top.',
  'https://via.placeholder.com/400x200?text=React+Vite'
);
