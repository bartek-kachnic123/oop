import { useContext } from 'react';
import { CartContext } from '../context/CartContext';

function Cart() {
  const { cart } = useContext(CartContext);

  return (
    <div>
      <h2>Koszyk</h2>

      {cart.length === 0 ? (
        <p>Twój koszyk jest pusty</p>
      ) : (
        cart.map((item, index) => (
          <div key={index}>
            <p>{item.name}</p>
            <p>{item.price} zł</p>
          </div>
        ))
      )}
    </div>
  );
}

export default Cart;

