const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../variaveis.env') });

const app = express();
const port = process.env.PORT;

// Rota Padrao ao acessar a localhost:3010 isso será informado
app.get('/', (req, res) => {
  res.send('Servidor está rodando!!!!!!!!!');
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

app.listen(port, () => {
  console.log(`Aplicativo Express.js rodando na porta ${port}`);
});
