require("dotenv").config();
const express = require("express");
const app = express();
const branchRouter = require("./api/branch/router");
const customerRouter = require("./api/customer/router");

app.use(express.json());

app.get("/", (req, res) => res.send("Hello World"));
app.use("/api/branch", branchRouter);
app.use("/api/customer", customerRouter);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log("Server listening on port", PORT);
});
