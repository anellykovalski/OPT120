const express = require('express');
const router = express.Router();

const connection = require('../servidor/ConexaoMySql.js');

// Rota para obter todos os usuários
router.get('/usuario', (req, res) => {
  try {
    connection.query('SELECT * FROM Usuario', (err, results) => {
      if (err) {
        res.status(500).json({ erro: err.message });
        return;
      }
      res.json(results);
    });
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao obter usuários: ' + error.message });
  }
});

// Rota para criar um novo usuário
router.post('/usuario', (req, res) => {
  try {
    const { nome, email, senha } = req.body;
    console.log(req.body);
    connection.query('INSERT INTO Usuario (NOME, EMAIL, SENHA) VALUES (?, ?, ?)', [nome, email, senha], (err, result) => {
      if (err) {
        res.status(500).json({ erro: err.message });
        return;
      }
      res.status(201).json({ mensagem: 'Usuário criado com sucesso', id: result.insertId });
    });
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao criar usuário: ' + error.message });
  }
});

// Rota para atualizar um usuário existente
router.put('/usuario/:id', (req, res) => {
  try {
    const id = req.params.id;
    const { nome, email, senha } = req.body;
    connection.query('UPDATE Usuario SET NOME = ?, EMAIL = ?, SENHA = ? WHERE ID_USUARIO = ?', [nome, email, senha, id], (err, result) => {
      if (err) {
        res.status(500).json({ erro: err.message });
        return;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Usuário não encontrado" });
        return;
      }
      res.json({ mensagem: 'Usuário atualizado com sucesso' });
    });
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao atualizar usuário: ' + error.message });
  }
});

// Rota para excluir um usuário
router.delete('/usuario/:id', (req, res) => {
  try {
    const id = req.params.id;
    connection.query('DELETE FROM Usuario WHERE ID_USUARIO = ?', id, (err, result) => {
      if (err) {
        res.status(500).json({ erro: err.message });
        return;
      }
      if (result.affectedRows === 0) {
        res.status(404).json({ mensagem: "Usuário não encontrado" });
        return;
      }
      res.json({ mensagem: 'Usuário excluído com sucesso' });
    });
  } catch (error) {
    res.status(500).json({ erro: 'Erro ao excluir usuário: ' + error.message });
  }
});

module.exports = router;