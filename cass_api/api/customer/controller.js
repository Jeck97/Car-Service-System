const service = require("./service");
const { genSaltSync, hashSync } = require("bcrypt");

module.exports = {
  create: (req, res) => {
    const data = req.body;
    data.password = hashSync(data.password, genSaltSync(10));
    service.create(data, (error, result) => {
      if (error) {
        return res.status(500).json({
          success: 0,
          message: error,
        });
      }
      return res.status(200).json({
        success: 1,
        message: result,
      });
    });
  },
  read: (req, res) => {
    service.read(null, (error, result) => {
      if (error) {
        return res.json({
          success: 0,
          message: error,
        });
      }
      return res.json({
        success: 1,
        message: result,
      });
    });
  },
};
