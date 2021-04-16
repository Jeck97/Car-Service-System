require("dotenv").config();
const express = require("express");
const app = express();
const userRouter = require("./api/customer/router");

app.use(express.json());

app.get("/", (req, res) => res.send("Hello World"));
app.use("/api/customer", userRouter);

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log("Server listening on port", PORT);
});
