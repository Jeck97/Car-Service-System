const { DB_CONN_ERR } = require("../../const");
const service = require("./service");

module.exports = {
  read: (req, res) => {
    service.selectServices(req.query.branch, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Services retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  readTasks: (req, res) => {
    service.selectTasks(req.query.service, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Tasks retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  readActions: (req, res) => {
    service.selectActions(
      req.query.service,
      req.query.actions,
      (error, results) => {
        // Database got some problem
        if (error) {
          console.log(error);
          return res.status(500).json({
            message: DB_CONN_ERR,
            data: null,
          });
        }
        // Actions retrieved successful
        return res.status(200).json({
          message: `${results.length} ${
            results.length > 1 ? "results" : "result"
          }`,
          data: results,
        });
      }
    );
  },
  readReserved: (req, res) => {
    service.selectReservedServices(req.query.branch, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Services retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
};
