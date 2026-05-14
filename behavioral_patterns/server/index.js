import express from 'express';
import cors from 'cors';

import * as productsController from './controllers/product_controller.js';
import * as paymentsController from './controllers/payments_controller.js';

const app = express();

app.use(cors({ origin: ['http://localhost:5173'] }));
app.use(express.json());

app.get('/products', productsController.getProducts);
app.post('/payments', paymentsController.createPayment);

const PORT = 5000;

app.listen(PORT, () => {
  console.log(`Server działa na porcie ${PORT}`);
});

