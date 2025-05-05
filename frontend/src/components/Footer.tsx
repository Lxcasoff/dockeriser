export default function Footer() {
    return (
      <footer className="bg-light border-top mt-5">
        <div className="container py-4 d-flex flex-column flex-md-row justify-content-between align-items-center">
          <div className="mb-3 mb-md-0 text-center text-md-start">
            <strong>© {new Date().getFullYear()} Blog Dev</strong> — Propulsé avec React, Bootstrap & Docker 🐳
          </div>
          <ul className="list-unstyled d-flex gap-3 mb-0 justify-content-center">
            <li>
              <a
                href="#"
                className="text-dark text-decoration-none"
                aria-label="Twitter"
              >
                <i className="bi bi-twitter fs-5"></i>
              </a>
            </li>
            <li>
              <a
                href="#"
                className="text-dark text-decoration-none"
                aria-label="GitHub"
              >
                <i className="bi bi-github fs-5"></i>
              </a>
            </li>
            <li>
              <a
                href="#"
                className="text-dark text-decoration-none"
                aria-label="LinkedIn"
              >
                <i className="bi bi-linkedin fs-5"></i>
              </a>
            </li>
          </ul>
        </div>
      </footer>
    );
  }
