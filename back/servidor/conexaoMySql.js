const mysql = require('mysql');

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "password",
    database: "mydb"
});

db.connect((err) => {
    if (err) {
      console.error('Erro ao conectar ao MySQL:', err);
      return;
    }
    console.log(`Conectado ao MySQL! host: ${db.config.host} | database: ${db.config.database} | user:${db.config.user}`);
});

module.exports = db;