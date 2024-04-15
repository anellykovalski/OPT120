// Importando os módulos necessários
const express = require('express');
const router = express.Router();

const connection = require('../servidor/ConexaoMySql.js');

// Rota para obter todas as relações entre usuários e atividade
router.get('/usuario-atividade', (req, res) => {
  connection.query('SELECT * FROM Usuario_Atividade', (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.json(results);
  });
});

// Rota para obter uma relação específica entre usuário e atividade por IDs
router.get('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  connection.query('SELECT * FROM Usuario_Atividade WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [usuarioId, atividadeId], (err, results) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (results.length === 0) {
      res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      return;
    }
    res.json(results[0]);
  });
});

// Rota para criar uma nova relação entre usuário e atividade
router.post('/usuario-atividade', (req, res) => {
  const { usuarioId, atividadeId, dataEntrega, nota } = req.body;
  connection.query('INSERT INTO Usuario_Atividade (`USUARIO.ID`, `ATIVIDADE.ID`, DATA_ENTREGA, NOTA) VALUES (?, ?, ?, ?)', [usuarioId, atividadeId, dataEntrega, nota], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    res.status(201).json({ mensagem: 'Relação usuário-atividade criada com sucesso', id: result.insertId });
  });
});

// Rota para atualizar uma relação entre usuário e atividade existente
router.put('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  const { dataEntrega, nota } = req.body;
  connection.query('UPDATE Usuario_Atividade SET DATA_ENTREGA = ?, NOTA = ? WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [dataEntrega, nota, usuarioId, atividadeId], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      return;
    }
    res.json({ mensagem: 'Relação usuário-atividade atualizada com sucesso' });
  });
});

// Rota para excluir uma relação entre usuário e atividade
router.delete('/usuario-atividade/:usuarioId/:atividadeId', (req, res) => {
  const usuarioId = req.params.usuarioId;
  const atividadeId = req.params.atividadeId;
  connection.query('DELETE FROM Usuario_Atividade WHERE `USUARIO.ID` = ? AND `ATIVIDADE.ID` = ?', [usuarioId, atividadeId], (err, result) => {
    if (err) {
      res.status(500).json({ erro: err.message });
      return;
    }
    if (result.affectedRows === 0) {
      res.status(404).json({ mensagem: "Relação entre usuário e atividade não encontrada" });
      return;
    }
    res.json({ mensagem: 'Relação usuário-atividade excluída com sucesso' });
  });
});

module.exports = router;