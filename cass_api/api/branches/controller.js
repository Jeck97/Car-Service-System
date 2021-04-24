const { DB_CONN_ERR, LOGIN_SUCCESS, LOGIN_INVALID } = require("../../const");
const service = require("./service");
const { compareSync } = require("bcrypt");

module.exports = {
  login: (req, res) => {
    const data = req.body;
    service.selectBranchByEmail(data.email, (error, result) => {
      // Database got some problem
      if (error) {
        console.log(error);
        return res.status(500).json({
          message: DB_CONN_ERR,
          data: null,
        });
      }
      // If the email not found in db
      if (!result) {
        return res.status(401).json({
          message: LOGIN_INVALID,
          data: null,
        });
      }
      const isMatched = compareSync(data.password, result.password);
      // If the password not matched with the corresponding email
      if (!isMatched) {
        return res.status(401).json({
          message: LOGIN_INVALID,
          data: null,
        });
      }
      // Email found and the corresponding password matched
      result.password = undefined;
      return res.status(200).json({
        message: LOGIN_SUCCESS,
        data: result,
      });
    });
  },
};
