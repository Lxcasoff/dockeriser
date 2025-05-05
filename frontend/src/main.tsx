import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom/client';


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
    <div className="max-w-3xl mx-auto mt-10 space-y-8">
      <h2 className="text-3xl font-bold text-gray-800">📝 Blog</h2>
      {posts.map(post => (
        <div key={post.id} className="p-6 bg-white shadow-md rounded-2xl">
          <h3 className="text-xl font-semibold text-gray-900">{post.title}</h3>
          <p className="text-sm text-gray-500">
            {new Date(post.created_at).toLocaleString()}
          </p>
          <p className="mt-4 text-gray-700">{post.content}</p>
        </div>
      ))}
    </div>
  );
}

function App() {
  return (
    <div>
      <h1>Bienvenue</h1>
      <Blog />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')!).render(<App />);

