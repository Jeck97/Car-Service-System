const pool = require("../../config/database");

module.exports = {
  insertCustomer: (data, callback) =>
    pool.query("INSERT INTO customer SET ?", data, (error) => callback(error)),
  selectAllCustomers: (callback) =>
    pool.query(
      'SELECT customer_id, name, phone_no, email, is_app_user, DATE_FORMAT(date_created, "%Y-%m-%d") as date_created FROM customer',
      [],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  updateCustomer: (id, data, callback) =>
    pool.query(
      "UPDATE customer SET ? WHERE customer_id = ?",
      [data, id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  updateCustomerPassword: (id, password, callback) =>
    pool.query(
      "UPDATE customer SET password = ? WHERE customer_id = ?",
      [password, id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
