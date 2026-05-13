const products = [
  { id: 1, name: 'Komputer', price: 13000 },
  { id: 2, name: 'Telefon', price: 2000 },
  { id: 3, name: 'IPHONE', price: 10000 },
];

export const getProducts = (req, res) => {
  res.json(products);
};

