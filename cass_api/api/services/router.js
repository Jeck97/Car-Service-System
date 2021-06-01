const controller = require("./controller");
const router = require("express").Router();

router.get("/", controller.read);

module.exports = router;
