CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO posts (title, content) VALUES
('Bienvenue sur notre blog', 'Ceci est notre tout premier article !'),
('Deuxième article', 'Voici un contenu plus long avec plus de détails.'),
('Troisième article', 'Nous aimons Docker et PostgreSQL 🐳');

