// Importando os módulos necessários
const express = require('express');
const router = express.Router();

const connection = require('../servidor/ConexaoMySql.js');

// Rota para obter todas as atividade
router.get('/atividade', (req, res) => {
  connection.query('SELECT * FROM Atividade', (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.json(results);
  });
});

// Rota para obter uma atividade específica por ID
router.get('/atividade/:id', (req, res) => {
  const id = req.params.id;
  connection.query('SELECT * FROM Atividade WHERE ID_ATIVIDADE = ?', id, (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (results.length === 0) {
      res.status(404).json({ mensagem: "Atividade não encontrada" });
      return;
    }
    res.json(results[0]);
  });
});

// Rota para criar uma nova atividade
router.post('/atividade', (req, res) => {
  const { TITULO, DESC, DATA } = req.body;
  connection.query('INSERT INTO Atividade (TITULO, DESC, DATA) VALUES (?, ?, ?)', [TITULO, DESC, DATA], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.status(201).json({ mensagem: 'Atividade criada com sucesso', id: result.insertId });
  });
});

// Rota para atualizar uma atividade existente
router.put('/atividade/:id', (req, res) => {
  const id = req.params.id;
  const { TITULO, DESC, DATA } = req.body;
  connection.query('UPDATE Atividade SET TITULO = ?, DESC = ?, DATA = ? WHERE ID_ATIVIDADE = ?', [TITULO, DESC, DATA, id], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Atividade não encontrada" });
      return;
    }
    res.json({ mensagem: 'Atividade atualizada com sucesso' });
  });
});

// Rota para excluir uma atividade
router.delete('/atividade/:id', (req, res) => {
  const id = req.params.id;
  connection.query('DELETE FROM Atividade WHERE ID_ATIVIDADE = ?', id, (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Atividade não encontrada" });
      return;
    }
    res.json({ mensagem: 'Atividade excluída com sucesso' });
  });
});

module.exports = router;