const { DB_CONN_ERR, ECONNREFUSED, ER_DUP_ENTRY } = require("../../const");
const service = require("./service");

module.exports = {
  read: (req, res) => {
    service.selectCars(req.query.customer, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Cars retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  readModels: (req, res) => {
    service.selectCarModels((error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Car models retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  readBrands: (req, res) => {
    service.selectCarBrands((error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Car brands retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  create: (req, res) => {
    service.insertCar(req.body, (error, results) => {
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
      // Car created successful
      return res.status(200).json({
        message: `Car ${req.body.car_plate_number} created successful`,
        data: results.insertId,
      });
    });
  },
};
