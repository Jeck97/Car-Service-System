const pool = require("../../config/database");

module.exports = {
  selectCars: (carId, callback) =>
    pool.query(
      `SELECT car_id, car_plate_number, car.car_model_id, car_model_name, car_model_type, car_model.car_brand_id, car_brand_name,
      DATE_FORMAT(car_date_to_service, "%Y-%m-%d") as car_date_to_service,
      DATE_FORMAT(car_date_from_service, "%Y-%m-%d") as car_date_from_service,
      car_distance_targeted, car_distance_completed, customer_id FROM car 
      JOIN car_model ON car.car_model_id = car_model.car_model_id 
      JOIN car_brand ON car_model.car_brand_id = car_brand.car_brand_id
      WHERE customer_id = ?`,
      [carId],
      (error, results) => (error ? callback(error) : callback(null, results))
    ),
  selectCarModels: (callback) =>
    pool.query("SELECT * FROM car_model", [], (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
  selectCarBrands: (callback) =>
    pool.query("SELECT * FROM car_brand", [], (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
  insertCar: (data, callback) =>
    pool.query("INSERT INTO car SET ?", data, (error) => callback(error)),
};
