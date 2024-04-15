const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const rotasAtividade = require('../rotas/rotas_atividade');
const rotasUsuario = require('../rotas/rotas_usuario');
const rotasUsuarioAtividade = require('../rotas/rotas_usuario_atividade');

const app = express();

app.get('/', (req, res) => {
  res.send('Servidor Rodando Corretamente!');
});

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json());
app.use(cors());

app.use(rotasAtividade);
app.use(rotasUsuario);
app.use(rotasUsuarioAtividade);

// Inicia o servidor
const PORT = 3020;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});