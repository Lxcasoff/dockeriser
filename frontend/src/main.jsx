import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom/client';

function App() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch('http://localhost:3001/api/data')
      .then(res => res.json())
      .then(setData)
      .catch(err => console.error('Fetch error:', err));
  }, []);

  return (
    <div>
      <h1>Données récupérées depuis le backend :</h1>
      <pre>{data ? JSON.stringify(data, null, 2) : 'Loading...'}</pre>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);

