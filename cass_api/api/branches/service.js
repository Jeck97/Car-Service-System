const pool = require("../../config/database");

module.exports = {
  selectBranch: (email, callback) => {
    pool.query(
      "SELECT * FROM branch WHERE branch_email = ?",
      [email],
      (error, results) => (error ? callback(error) : callback(null, results[0]))
    );
  },
};
