const { DB_CONN_ERR } = require("../../const");
const service = require("./service");

module.exports = {
  read: (req, res) => {
    service.selectReservations(req.params.customer_id, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // TODO: 404 not found
      // Reservation retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
};
