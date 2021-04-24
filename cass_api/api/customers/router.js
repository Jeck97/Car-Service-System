const controller = require("./controller");
const router = require("express").Router();

router.post("/", controller.create);
router.get("/", controller.readAll);
router.put("/:customer_id", controller.update);
router.patch("/:customer_id", controller.updatePassword);

module.exports = router;
