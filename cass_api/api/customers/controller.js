const {
  ECONNREFUSED,
  DB_CONN_ERR,
  ER_DUP_ENTRY,
  LOGIN_INVALID,
  LOGIN_SUCCESS,
} = require("../../const");
const service = require("./service");
const { genSaltSync, hashSync, compareSync } = require("bcrypt");

module.exports = {
  login: (req, res) => {
    const email = req.body.customer_email;
    const password = req.body.customer_password;
    service.selectCustomer(email, (error, result) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // If the email not found in db
      if (!result) {
        return res.status(401).json({
          message: LOGIN_INVALID,
          data: null,
        });
      }
      const isMatched = result.customer_password
        ? compareSync(password, result.customer_password)
        : false;
      // If the password not matched with the corresponding email
      if (!isMatched) {
        return res.status(401).json({
          message: LOGIN_INVALID,
          data: null,
        });
      }
      // Email found and the corresponding password matched
      result.customer_password = undefined;
      return res.status(200).json({
        message: LOGIN_SUCCESS,
        data: result,
      });
    });
  },
  create: (req, res) => {
    var { customer_name, customer_password } = req.body;
    if (customer_password != null)
      req.body.customer_password = hashSync(customer_password, genSaltSync(10));
    service.insertCustomer(req.body, (error, results) => {
      if (error) {
        // Database got some problem
        console.log(error);
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
        message: `Customer ${customer_name} registered successful`,
        data: results.insertId,
      });
    });
  },
  read: (req, res) => {
    service.selectCustomers(req.query.search, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Customers retrieved successful
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
