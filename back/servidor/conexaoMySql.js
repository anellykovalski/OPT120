const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../variaveis.env') });

const mysql = require('mysql');

const db = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USERDB,
    password: process.env.PASSWORDDB,
    database: process.env.NAMEDB
});

db.connect((err) => {
    if (err) {
      console.error('Erro ao conectar ao MySQL:', err);
      return;
    }
    console.log(`Conectado ao MySQL! host: ${db.config.host} | database: ${db.config.database} | user:${db.config.user}`);
});

module.exports = db;
