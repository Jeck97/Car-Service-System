const controller = require("./controller");
const router = require("express").Router();

router.get("/", controller.read);
router.get("/servicings", controller.readServicings);
router.patch("/:id", controller.updateStatus);
router.post("/", controller.create);
router.patch("/servicings/:id", controller.updateServicing);
router.get("/servicings/:id", controller.readServicing);
router.get("/statistics", controller.readStatistics);
router.delete("/servicings/:id", controller.deleteServicing);

module.exports = router;
