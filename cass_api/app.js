require("dotenv").config();
const express = require("express");
const app = express();
const branchRouter = require("./api/branches/router");
const customerRouter = require("./api/customers/router");
const carRouter = require("./api/cars/router");
const reservationRouter = require("./api/reservations/router");

app.use(express.json());

app.get("/", (req, res) => res.send("Hello World"));
app.use("/cass/api/branches", branchRouter);
app.use("/cass/api/customers", customerRouter);
app.use("/cass/api/cars", carRouter);
app.use("/cass/api/reservations", reservationRouter);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log("Server listening on port", PORT));
