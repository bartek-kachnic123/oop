import { useState, useMemo } from 'react';
import { CartContext } from './CartContext';

export function CartProvider({ children }) {
  const [cart, setCart] = useState([]);

  const addToCart = (product) => {
    setCart((prev) => [
      ...prev,
      { ...product, id: crypto.randomUUID() }
    ]);
  };

  const clearCart = () => {
    setCart([]);
  };

  const value = useMemo(() => ({
    cart,
    addToCart,
    clearCart,
  }), [cart]);

  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
}

