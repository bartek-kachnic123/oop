import { Routes, Route, Link } from 'react-router';

import Products from './components/Products';
import Payments from './components/Payments';
import Cart from './components/Cart';
import { CartProvider } from './context/CartProvider';

function App() {
  return (
    <CartProvider>
      <div>
        <h1>Sklep</h1>
        <nav style={{ display: "flex", gap: "10px", marginBottom: "20px" }}>
          <Link to="/">Produkty</Link>
          <Link to="/payments">Płatności</Link>
          <Link to="/cart">Koszyk</Link>
        </nav>
        <Routes>
          <Route path="/" element={<Products />} />
          <Route path="/payments" element={<Payments />} />
          <Route path="/cart" element={<Cart />} />
        </Routes>
      </div>
    </CartProvider>
  );
}

export default App;

