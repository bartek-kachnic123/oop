const products = [
  { id: 1, name: "Laptop", price: 3000 },
  { id: 2, name: "Telefon", price: 2000 },
  { id: 3, name: "Monitor", price: 1000 },
];

export const getProducts = (req, res) => {
  res.json(products);
};

