import { useEffect, useState } from 'react';
import Header from './components/Header';
import Footer from './components/Footer';
import BlogCard from './components/BlogCard';
import Toast from './components/Toast';

type Post = {
  id: number;
  title: string;
  content: string;
  created_at: string;
  image_url: string;
};

export default function App() {
  const [posts, setPosts] = useState<Post[]>([]);
  const [newPostTitle, setNewPostTitle] = useState<string | null>(null);

  useEffect(() => {
    fetch('http://localhost:3001/api/posts')
      .then(res => res.json())
      .then(setPosts);

    // WebSocket pour recevoir les nouveaux articles
    const ws = new WebSocket('ws://localhost:5555');

    ws.onmessage = (event) => {
      const post: Post = JSON.parse(event.data);
      setNewPostTitle(post.title);
      setPosts(prev => [post, ...prev]);
    };

    return () => ws.close();
  }, []);

  return (
    <div className="min-vh-100 d-flex flex-column">
      <Header />
      <main className="container py-5 flex-grow-1">
        <div className="row g-4">
          {posts.map(post => (
            <div className="col-sm-6 col-lg-4" key={post.id}>
              <BlogCard
                title={post.title}
                content={post.content}
                date={new Date(post.created_at).toLocaleDateString()}
                image={post.image_url}
              />
            </div>
          ))}
        </div>
      </main>
      <Footer />
      {newPostTitle && (
        <Toast
          message={`🆕 Nouvel article publié : ${newPostTitle}`}
          onClose={() => setNewPostTitle(null)}
        />
      )}
    </div>
  );
}
