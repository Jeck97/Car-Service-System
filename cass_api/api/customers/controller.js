const { ECONNREFUSED, DB_CONN_ERR, ER_DUP_ENTRY } = require("../../const");
const service = require("./service");
const { genSaltSync, hashSync } = require("bcrypt");

module.exports = {
  create: (req, res) => {
    var { password } = req.body;
    if (password != null) password = hashSync(password, genSaltSync(10));
    service.insertCustomer(res.body, (error) => {
      if (error) {
        // Database got some problem
        if (error.errno == ECONNREFUSED) {
          return res.status(500).json({
            message: DB_CONN_ERR,
            data: null,
          });
        }
        // Duplicate data
        if (error.errno == ER_DUP_ENTRY) {
          const splited = error.sqlMessage.split("'");
          return res.status(409).json({
            message: `${splited[3]} ${splited[1]} already exist`,
            data: null,
          });
        }
      }
      // Customer created successful
      return res.status(200).json({
        message: `Customer ${data.name} created successful`,
        data: null,
      });
    });
  },
  readAll: (req, res) => {
    service.selectAllCustomers((error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Customers retrieved successful
      results.forEach(
        (result) => (result.is_app_user = result.is_app_user == 1)
      );
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  update: (req, res) => {
    const customer_id = req.params.customer_id;
    service.updateCustomer(customer_id, req.body, (error, results) => {
      if (error) {
        // Database got some problem
        if (error.errno == ECONNREFUSED) {
          return res.status(500).json({
            message: DB_CONN_ERR,
            data: null,
          });
        }
        // Duplicate data
        if (error.errno == ER_DUP_ENTRY) {
          const splited = error.sqlMessage.split("'");
          return res.status(409).json({
            message: `${splited[3]} ${splited[1]} already exist`,
            data: null,
          });
        }
      }
      // Customer ID not found
      if (results.affectedRows == 0) {
        return res.status(404).json({
          message: `Customer ${customer_id} does not found`,
          data: null,
        });
      }
      // Customer updated successful
      return res.status(200).json({
        message: `Customer ${customer_id} had been updated`,
        data: null,
      });
    });
  },
  updatePassword: (req, res) => {
    const customer_id = req.params.customer_id;
    var { password } = req.body;
    password = hashSync(password, genSaltSync(10));
    service.updateCustomerPassword(customer_id, password, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Customer ID not found
      if (results.affectedRows == 0) {
        return res.status(404).json({
          message: `Customer ${customer_id} does not found`,
          data: null,
        });
      }
      // // Same password are used
      // if (results.changedRows == 0) {
      //   return res.status(409).json({
      //     message: "New password cannot be same with the old password",
      //     data: null,
      //   });
      // }
      // Customer updated successful
      return res.status(200).json({
        message: `Password of customer ${customer_id} had been updated`,
        data: null,
      });
    });
  },
};
