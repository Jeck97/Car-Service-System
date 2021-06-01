const pool = require("../../config/database");

module.exports = {
  selectReservations: (id, key, callback) => {
    let condition = "";
    if (key === "customer") condition = "customer_id = ?";
    else if (key === "branch") condition = "branch_id = ?";
    pool.query(
      `SELECT * FROM reservation 
      NATURAL JOIN car 
      NATURAL JOIN car_model 
      NATURAL JOIN branch_service 
      NATURAL JOIN branch 
      NATURAL JOIN service 
      NATURAL JOIN customer 
      WHERE ${condition} ORDER BY reservation_id`,
      [id],
      (error, results) => (error ? callback(error) : callback(null, results))
    );
  },
  updateReservationStatus: (id, status, callback) =>
    pool.query(
      "UPDATE reservation SET reservation_status = ? WHERE reservation_id = ?",
      [status, id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  insertReservation: (data, callback) =>
    pool.query("INSERT INTO reservation SET ?", data, (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
};
