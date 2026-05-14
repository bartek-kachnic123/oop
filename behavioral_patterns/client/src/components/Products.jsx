import { useEffect, useState, useContext } from 'react';
import api from '../api';
import { CartContext } from '../context/CartContext';

function Products() {
  const [products, setProducts] = useState([]);
  const { addToCart } = useContext(CartContext);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const res = await api.get('/products');
        setProducts(res.data);
      } catch (err) {
        console.error(err);
      }
    };

    fetchProducts();
  }, []);

  return (
    <div style={{ width: "300px", margin: "40px auto" }}>
      <h2>Produkty</h2>

      {products.map((product) => (
        <div
          key={product.id}
          style={{ border: "1px solid #ccc", padding: 10 }}
        >
          <p>{product.name}</p>
          <p>{product.price} zł</p>

          <button onClick={() => addToCart(product)}>
            Dodaj do koszyka
          </button>
        </div>
      ))}
    </div>
  );
}

export default Products;

