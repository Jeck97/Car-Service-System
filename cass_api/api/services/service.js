const pool = require("../../config/database");

module.exports = {
  selectServices: (branchId, callback) =>
    pool.query(
      "SELECT * FROM branch_service NATURAL JOIN service WHERE branch_id = ? AND bs_enabled = true",
      [branchId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  selectTasks: (serviceId, callback) =>
    pool.query(
      "SELECT * FROM task WHERE service_id = ?",
      [serviceId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  selectActions: (taskId, actions, callback) => {
    const condition = actions ? ` AND action_id IN (${actions})` : "";
    pool.query(
      `SELECT * FROM action NATURAL JOIN task WHERE service_id = ? ${condition}`,
      [taskId],
      (error, results) => (error ? callback(error) : callback(null, results))
    );
  },
  selectReservedServices: (branchId, callback) =>
    pool.query(
      "SELECT *, COUNT(reservation.service_id) AS service_count FROM service NATURAL JOIN branch_service LEFT JOIN reservation USING(service_id) WHERE branch_service.branch_id = ? GROUP BY service.service_id",
      [branchId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
