const controller = require("./controller");
const router = require("express").Router();

router.get("/", controller.read);
router.patch("/:id", controller.updateStatus);
router.post("/", controller.create);

module.exports = router;
