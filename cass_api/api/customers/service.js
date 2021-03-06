const pool = require("../../config/database");

module.exports = {
  insertCustomer: (data, callback) =>
    pool.query("INSERT INTO customer SET ?", data, (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
  selectCustomer: (email, callback) =>
    pool.query(
      "SELECT * FROM customer WHERE customer_email = ?",
      [email],
      (error, results) => (error ? callback(error) : callback(null, results[0]))
    ),
  selectCustomers: (search, callback) =>
    search
      ? pool.query(
          `SELECT customer_id, customer_name, customer_phone_number, customer_email, customer_type, customer_datetime_registered FROM customer 
          WHERE customer_name LIKE ? OR customer_phone_number LIKE ? OR customer_email LIKE ?`,
          [`%${search}%`, `%${search}%`, `%${search}%`],
          (error, results) =>
            error ? callback(error) : callback(null, results)
        )
      : pool.query(
          "SELECT customer_id, customer_name, customer_phone_number, customer_email, customer_type, customer_datetime_registered FROM customer",
          [],
          (error, results) =>
            error ? callback(error) : callback(null, results)
        ),
  updateCustomer: (id, data, callback) =>
    pool.query(
      "UPDATE customer SET ? WHERE customer_id = ?",
      [data, id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  updateCustomerPassword: (id, password, callback) =>
    pool.query(
      "UPDATE customer SET customer_password = ? WHERE customer_id = ?",
      [password, id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
