import { useState } from "react";
import config from "../config";

function Payments() {
  const [amount, setAmount] = useState("");

  const handlePayment = async () => {
    if (!amount) return;

    const payment = {
      amount,
      date: new Date(),
    };

    try {
      const response = await fetch(`${config.API_URL}/payments`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payment),
      });

      const data = await response.json();

      console.log(data);

      alert("Płatność wysłana");

      setAmount("");
    } catch (error) {
      console.error(error);
      alert("Błąd płatności");
    }
  };

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
      <h2>Płatności</h2>

      <input
        type="number"
        placeholder="Kwota"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        style={{
          padding: "10px",
          fontSize: "16px",
        }}
      />

      <button
        onClick={handlePayment}
        style={{
          padding: "10px",
          fontSize: "16px",
          cursor: "pointer",
        }}
      >
        Zapłać
      </button>
    </div>
  );
}

export default Payments;

