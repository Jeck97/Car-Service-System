const pool = require("../../config/database");

module.exports = {
  selectReservations: (customerId, callback) =>
    pool.query(
      `SELECT reservation_id, 
      DATE_FORMAT(reservation_datetime_reserved, "%Y-%m-%d %T") AS reservation_datetime_reserved,
      DATE_FORMAT(reservation_datetime_to_service, "%Y-%m-%d %T") AS reservation_datetime_to_service,
      reservation_status, reservation_remark,
      car.car_id, car.car_plate_number, branch.branch_id, branch.branch_name, service.service_id, service.service_name
      FROM reservation
      JOIN car ON reservation.car_id = car.car_id
      JOIN branch_service ON reservation.bs_id = branch_service.bs_id
      JOIN branch ON branch_service.branch_id = branch.branch_id
      JOIN service ON branch_service.service_id = service.service_id
      JOIN customer ON car.customer_id = customer.customer_id
      WHERE car.customer_id = ?`,
      [customerId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
};
