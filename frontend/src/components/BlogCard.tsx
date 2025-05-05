type Props = {
    title: string;
    content: string;
    date: string;
    image: string;
  };
  
  export default function BlogCard({ title, content, date, image }: Props) {
    return (
      <div className="card h-100 shadow-sm">
        <img src={image} className="card-img-top" alt={title} />
        <div className="card-body d-flex flex-column">
          <h5 className="card-title">{title}</h5>
          <p className="text-muted" style={{ fontSize: '0.8rem' }}>{date}</p>
          <p className="card-text flex-grow-1">{content}</p>
          <a href="#" className="btn btn-primary mt-3 align-self-start">
            Lire plus
          </a>
        </div>
      </div>
    );
  }
  