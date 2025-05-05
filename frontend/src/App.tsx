import { useEffect, useState } from 'react';
import Header from './components/Header';
import Footer from './components/Footer';
import BlogCard from './components/BlogCard';

type Post = {
  id: number;
  title: string;
  content: string;
  created_at: string;
  image_url: string;
};

export default function App() {
  const [posts, setPosts] = useState<Post[]>([]);

  useEffect(() => {
    fetch('http://localhost:3001/api/posts')
      .then(res => res.json())
      .then(setPosts);
  }, []);

  return (
    <div className="d-flex flex-column min-vh-100">
      <Header />
      <main className="container my-5 flex-grow-1">
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
    </div>
  );
}
