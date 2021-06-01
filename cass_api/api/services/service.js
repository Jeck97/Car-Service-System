const pool = require("../../config/database");

module.exports = {
  selectServices: (branchId, callback) =>
    pool.query(
      "SELECT * FROM branch_service NATURAL JOIN service WHERE branch_id = ? AND bs_enabled = true",
      [branchId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
