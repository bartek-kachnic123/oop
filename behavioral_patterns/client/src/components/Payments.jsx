import { useContext } from 'react';
import api from '../api';
import { CartContext } from '../context/CartContext';

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
      await api.post('/payments', payment);

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

