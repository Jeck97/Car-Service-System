const pool = require("../../config/database");

module.exports = {
  getBranchByEmail: (email, callback) => {
    pool.query(
      "SELECT * FROM BRANCH WHERE EMAIL = ?",
      [email],
      (error, results) => (error ? callback(error) : callback(null, results[0]))
    );
  },
};
