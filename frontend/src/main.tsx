import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';

type Post = {
  id: number;
  title: string;
  content: string;
  created_at: string;
};

function Blog() {
  const [posts, setPosts] = useState<Post[]>([]);

  useEffect(() => {
    fetch('http://localhost:3001/api/posts')
      .then(res => res.json())
      .then(setPosts)
      .catch(err => console.error('Fetch error:', err));
  }, []);

  return (
    <div className="grid gap-6">
      {posts.map((post) => (
        <div
          key={post.id}
          className="bg-white shadow-lg rounded-xl p-6 border border-gray-200 hover:shadow-xl transition-shadow"
        >
          <h2 className="text-2xl font-bold text-indigo-700">{post.title}</h2>
          <p className="text-sm text-gray-500">{new Date(post.created_at).toLocaleString()}</p>
          <p className="mt-4 text-gray-800">{post.content}</p>
        </div>
      ))}
    </div>
  );
}

function App() {
  return (
    <div className="min-h-screen bg-gray-100 text-gray-900 font-sans">
      {/* Header */}
      <header className="bg-white shadow-md py-4 mb-10">
        <div className="max-w-4xl mx-auto px-4 flex justify-between items-center">
          <h1 className="text-3xl font-extrabold text-indigo-800">🚀 My Dev Blog</h1>
          <nav className="space-x-4">
            <a href="#" className="text-gray-600 hover:text-indigo-600">Accueil</a>
            <a href="#" className="text-gray-600 hover:text-indigo-600">À propos</a>
            <a href="#" className="text-gray-600 hover:text-indigo-600">Contact</a>
          </nav>
        </div>
      </header>

      {/* Contenu */}
      <main className="max-w-4xl mx-auto px-4">
        <Blog />
      </main>

      {/* Footer */}
      <footer className="text-center text-sm text-gray-500 mt-16 py-6">
        © {new Date().getFullYear()} Blog développé avec React, Tailwind et Docker 🐳
      </footer>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')!).render(<App />);
