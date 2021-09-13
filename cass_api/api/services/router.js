const controller = require("./controller");
const router = require("express").Router();

router.get("/", controller.read);
router.get("/tasks", controller.readTasks);
router.get("/tasks/actions", controller.readActions);
router.get("/reserved", controller.readReserved);

module.exports = router;
