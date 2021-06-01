const pool = require("../../config/database");

module.exports = {
  selectBranch: (email, callback) =>
    pool.query(
      "SELECT * FROM branch WHERE branch_email = ?",
      [email],
      (error, results) => (error ? callback(error) : callback(null, results[0]))
    ),
  selectBranches: (callback) =>
    pool.query(
      "SELECT branch_id, branch_name, branch_email, branch_location FROM branch",
      [],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
