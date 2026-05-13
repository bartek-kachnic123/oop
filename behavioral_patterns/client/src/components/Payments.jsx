import { useContext } from 'react';
import { CartContext } from '../context/CartContext';
import config from '../config';

function Payments() {
  const { cart, clearCart } = useContext(CartContext);

  const totalAmount = cart.reduce((sum, item) => sum + item.price, 0);

  const handlePayment = async () => {
    if (!cart.length) return;

    const payment = {
      amount: totalAmount,
      date: new Date(),
    };

    try {
      await fetch(`${config.API_URL}/payments`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payment),
      });

      alert('Płatność wysłana');
      clearCart();
    } catch (error) {
      console.error(error);
      alert('Błąd płatności');
    }
  };

  return (
    <div style={{ width: "300px", margin: "40px auto" }}>
      <h2>Płatności</h2>

      <p>Do zapłaty: {totalAmount} zł</p>

      <button onClick={handlePayment}>
        Zapłać
      </button>
    </div>
  );
}

export default Payments;

