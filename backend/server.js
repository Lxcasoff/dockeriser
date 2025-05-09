require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { Pool } = require('pg');
const path = require('path');

const app = express();

// 🛡️ Sécurité
app.use(helmet()); // Headers HTTP sécurisés
// Autoriser toutes les origines pour CORS (à ajuster en production)
app.use(cors());
app.use(express.json());

// 🚫 Limitation des requêtes
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // max 100 requêtes par IP
});
app.use(limiter);

// 📁 Exposition des images statiques si tu as des images locales
app.use('/images', express.static(path.join(__dirname, 'public/images')));

// 🔌 Connexion PostgreSQL
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME
});

// 📰 Endpoint pour les articles
app.get('/api/posts', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM posts ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error('❌ Erreur DB:', err);
    res.status(500).json({ error: 'DB query failed' });
  }
});

// Health check endpoint
app.get('/', (req, res) => {
  res.status(200).send('OK');
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`✅ Backend listening on http://localhost:${PORT}`));
