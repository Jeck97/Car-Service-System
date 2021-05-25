const controller = require("./controller");
const router = require("express").Router();

router.get("/:customer_id", controller.read);

module.exports = router;
