const controller = require("./controller");
const router = require("express").Router();

router.get("/", controller.read);
router.get("/models", controller.readModels);
router.get("/brands", controller.readBrands);
router.post("/", controller.create);

module.exports = router;
