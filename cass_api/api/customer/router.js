const controller = require("./controller");
const router = require("express").Router();

router.post("/", controller.create);
router.get("/", controller.read);

module.exports = router;
