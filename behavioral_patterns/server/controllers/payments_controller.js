export const createPayment = (req, res) => {
  const paymentData = req.body;

  console.log('Otrzymana płatność:', paymentData);

  res.json({
    message: 'Płatność przyjęta',
    data: paymentData,
  });
};

