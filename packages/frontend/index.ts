
import express, {Request, Response} from "express";
import bodyParser from "body-parser";
const upload = require("express-fileupload");
const cookieParser = require("cookie-parser");

const app = express();
app.use(cookieParser());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(upload());

app.set("view engine", "ejs");
app.set("views", __dirname + "/views");
app.use("/css", express.static(__dirname + "/public/css"));
app.use("/img", express.static(__dirname + "/public/img"));
app.use("/js", express.static(__dirname + "/public/js"));

const PORT = 8088;

app.get("/", (req: Request, res: Response) => {
  res.render("index");
});

app.listen(PORT, () => {
  console.log(`app running on http://localhost:${PORT}`);
});
