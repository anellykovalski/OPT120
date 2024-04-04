const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const conexao = require('conexaoMySql.js');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../variaveis.env') });

const app = express();
const port = process.env.PORT;

// Rota Padrao ao acessar a localhost:3010 isso será informado
app.get('/', (req, res) => {
  res.send('Servidor está rodando!');
});

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());

app.get('/usuario', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Usuario';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

app.get('/atividade', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Atividade';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

app.get('/usuario_atividade', (req, res) => {
  // Query SQL para selecionar todos os usuários
  const sql = 'SELECT * FROM Usuario_Atividade';

  // Executa a consulta
  conexao.query(sql, (error, results) => {
    if (error) {
      // Se houver um erro, envia uma resposta de erro
      return res.status(500).json({ error: 'Erro ao executar a consulta no banco de dados' });
    }

    // Se a consulta for bem-sucedida, envia os resultados como resposta
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Aplicativo Express.js rodando na porta ${port}`);
});
