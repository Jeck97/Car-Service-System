const { createPool } = require("mysql");

const pool = createPool({
  port: process.env.DB_PORT,
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  timezone: process.env.DB_TIME_ZONE,
  database: process.env.MYSQL_DB,
});

module.exports = pool;
