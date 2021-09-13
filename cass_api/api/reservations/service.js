const { query } = require("../../config/database");
const pool = require("../../config/database");

module.exports = {
  selectReservations: (id, key, isToday, callback) => {
    let condition = "";
    if (key === "branch") condition = "branch_id = ?";
    else condition = "customer_id = ?"; // key === "customer"
    if (isToday)
      condition += " AND DATE(`reservation_datetime_to_service`) = CURDATE()";
    pool.query(
      `SELECT * FROM reservation 
      NATURAL JOIN car 
      NATURAL JOIN car_model 
      NATURAL JOIN branch_service 
      NATURAL JOIN branch 
      NATURAL JOIN service 
      NATURAL JOIN customer 
      LEFT JOIN servicing_reservation USING(reservation_id) 
      WHERE ${condition} ORDER BY reservation_datetime_to_service`,
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
  selectServicingReservations: (callback) =>
    pool.query("SELECT * FROM servicing_reservation", [], (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
  updateServicingReservation: (id, data, callback) =>
    pool.query(
      "UPDATE `servicing_reservation` SET `sr_progress` = ?,`sr_step` = ?,`sr_step_total` = ?,`sr_actions` = ?,`sr_actions_accepted`= ? WHERE `reservation_id`= ?",
      [
        data.sr_progress,
        data.sr_step,
        data.sr_step_total,
        data.sr_actions,
        data.sr_actions_accepted,
        id,
      ],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  selectServicingReservation: (id, type, callback) => {
    const query = type
      ? "SELECT * FROM servicing_reservation NATURAL JOIN reservation NATURAL JOIN branch NATURAL JOIN service NATURAL JOIN car WHERE car.customer_id = ? ORDER BY sr_id"
      : "SELECT * FROM servicing_reservation WHERE reservation_id = ? ORDER BY sr_id";
    pool.query(query, [id], (error, results) =>
      error ? callback(error) : callback(null, results[0])
    );
  },
  selectReservationStatistics: (id, callback) =>
    pool.query(
      "SELECT DATE(reservation_datetime_to_service) AS `date`, COUNT(DATE(reservation_datetime_to_service)) AS `count` FROM `reservation` WHERE branch_id = ? GROUP BY YEAR(reservation_datetime_to_service), MONTH(reservation_datetime_to_service) ORDER BY DATE(reservation_datetime_to_service)",
      [id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  deleteServicingReservation: (id, callback) =>
    pool.query(
      "DELETE FROM `servicing_reservation` WHERE `sr_id` = ?",
      [id],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
