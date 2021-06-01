const controller = require("./controller");
const router = require("express").Router();

router.post("/login", controller.login);
router.get("/", controller.read);

module.exports = router;
