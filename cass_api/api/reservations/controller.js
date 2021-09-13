const { DB_CONN_ERR } = require("../../const");
const service = require("./service");

module.exports = {
  read: (req, res) => {
    const key = Object.keys(req.query)[0];
    const id = req.query[key];
    const isToday = req.query["today"] === "true";
    service.selectReservations(id, key, isToday, (error, results) => {
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
  updateStatus: (req, res) => {
    const id = req.params.id;
    const { reservation_status } = req.body;
    service.updateReservationStatus(
      id,
      reservation_status,
      (error, results) => {
        // Database got some problem
        if (error) {
          console.log(error);
          return res.status(500).json({
            message: DB_CONN_ERR,
            data: null,
          });
        }
        // Reservation ID not found
        if (results.affectedRows == 0) {
          return res.status(404).json({
            message: `Reservation ${id} does not found`,
            data: null,
          });
        }
        // Reservation status does not updated due to status values are same
        if (results.changedRows == 0) {
          return res.status(409).json({
            message: `Reservation status has not updated due to the status already is "${reservation_status}"`,
            data: null,
          });
        }
        // Reservation status updated successful
        return res.status(200).json({
          message: `Status of Reservation ${id} had been updated to ${reservation_status}`,
          data: null,
        });
      }
    );
  },
  create: (req, res) => {
    service.insertReservation(req.body, (error, results) => {
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
      // Reservation created successful
      return res.status(200).json({
        message: `Reservation ${results.insertId} created successful`,
        data: results.insertId,
      });
    });
  },
  readServicings: (req, res) => {
    service.selectServicingReservations((error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Servicing reservation retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  updateServicing: (req, res) => {
    const id = req.params.id;
    service.updateServicingReservation(id, req.body, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Servicing reservation ID not found
      if (results.affectedRows == 0) {
        return res.status(404).json({
          message: `Reservation ${id} does not found`,
          data: null,
        });
      }
      // Servicing reservation has not updated as the data values are same
      if (results.changedRows == 0) {
        return res.status(409).json({
          message: `Servicing reservation has not updated as the data values are same"`,
          data: null,
        });
      }
      // Servicing reservation updated successful
      return res.status(200).json({
        message: `Servicing reservation ${id} had been updated successful`,
        data: null,
      });
    });
  },
  readServicing: (req, res) => {
    const id = req.params.id;
    const type = req.query.type === "customer";
    service.selectServicingReservation(id, type, (error, result) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Servicing reservation not found
      if (!result) {
        return res.status(404).json({
          message: "Result not found",
          data: null,
        });
      }
      // Servicing reservation retrieved successful
      return res.status(200).json({
        message: "Result found",
        data: result,
      });
    });
  },
  readStatistics: (req, res) => {
    service.selectReservationStatistics(req.query.branch, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // TODO: 404 not found
      // Reservation statistics retrieved successful
      return res.status(200).json({
        message: `${results.length} ${
          results.length > 1 ? "results" : "result"
        }`,
        data: results,
      });
    });
  },
  deleteServicing: (req, res) => {
    const id = req.params.id;
    service.deleteServicingReservation(id, (error, results) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // Servicing reservation ID not found
      if (results.affectedRows == 0) {
        return res.status(404).json({
          message: `Servicing ${id} does not found`,
          data: null,
        });
      }
      // Servicing reservation updated successful
      return res.status(200).json({
        message: `Servicing reservation ${id} had been deleted successful`,
        data: null,
      });
    });
  },
};
