const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const conexao = require('conexaoMySql.js');
const path = require('path');
const app = express();
const port = process.env.PORT;

// Rota Padrao ao acessar a localhost:3010 isso será informado

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

const port = 3001;
app.listen(port, () => {
  console.log(`Aplicativo Express.js rodando na porta ${port}`);
});
