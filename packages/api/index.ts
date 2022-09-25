
import express, {Request, Response} from "express";
import bodyParser from "body-parser";
const upload = require("express-fileupload");
const cookieParser = require("cookie-parser");
const { PrismaClient }  = require('@prisma/client');

const prisma = new PrismaClient()
const app = express();
app.use(cookieParser());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(upload());

const PORT = 8088;
const saltRounds = 10;

import {
  userRouter,
  userAuth
} from "./routes/index";

app.use(userAuth);

app.get("/", (req: Request, res: Response) => {
  res.send("Welcome to the server");
});

app.use("/user", userRouter);

app.listen(PORT, () => {
  console.log(`api running on http://localhost:${PORT}`);
});
