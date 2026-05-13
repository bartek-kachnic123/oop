import { useEffect, useState } from 'react';
import config from '../config';

function Products() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetch(`${config.API_URL}/products`)
      .then((res) => res.json())
      .then((data) => setProducts(data))
      .catch((err) => console.error(err));
  }, []);

  return (
    <div
      style={{
        width: "300px",
        margin: "40px auto",
        display: "flex",
        flexDirection: "column",
        gap: "10px",
      }}
    >
      <h2>Produkty</h2>

      {products.map((product) => (
        <div
          key={product.id}
          style={{
            padding: "10px",
            border: "1px solid #ccc",
            borderRadius: "6px",
          }}
        >
          <p>{product.name}</p>
          <p>{product.price} zł</p>
        </div>
      ))}
    </div>
  );
}

export default Products;

