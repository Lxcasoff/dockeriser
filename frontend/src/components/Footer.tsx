export default function Footer() {
    return (
      <footer className="bg-light text-center py-4 mt-5 border-top">
        <div className="container">
          © {new Date().getFullYear()} Blog développé avec React, Bootstrap et Docker 🐳
        </div>
      </footer>
    );
  }
  