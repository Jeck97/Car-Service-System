const pool = require("../../config/database");

module.exports = {
  create: (data, callback) => {
    pool.query(
      "INSERT INTO CUSTOMER(NAME, PHONE_NO, EMAIL, PASSWORD, IS_APP_USER) VALUES(?,?,?,?,?)",
      [data.name, data.phone_no, data.email, data.password, data.is_app_user],
      (error, results) => (error ? callback(error) : callback(null, results))
    );
  },
  read: (data, callback) => {
    pool.query(
      "SELECT CUSTOMER_ID, NAME, PHONE_NO, EMAIL, IS_APP_USER FROM CUSTOMER",
      [],
      (error, results) => (error ? callback(error) : callback(null, results))
    );
  },
};

