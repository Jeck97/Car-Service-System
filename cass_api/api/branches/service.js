const pool = require("../../config/database");

module.exports = {
  selectBranchByEmail: (email, callback) => {
    pool.query(
      "SELECT * FROM branch WHERE email = ?",
      [email],
      (error, results) => (error ? callback(error) : callback(null, results[0]))
    );
  },
};
