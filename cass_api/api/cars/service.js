const pool = require("../../config/database");

module.exports = {
  selectCars: (customerId, callback) =>
    pool.query(
      "SELECT * FROM car NATURAL JOIN car_model NATURAL JOIN car_brand WHERE customer_id = ?",
      [customerId],
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
    pool.query("INSERT INTO car SET ?", data, (error, results) =>
      error ? callback(error) : callback(null, results)
    ),
};
