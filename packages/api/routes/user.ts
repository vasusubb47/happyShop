
import express, {Request, Response} from 'express';
// import PrismaClient from '@prisma/client';
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

import { userAuth } from "./middleware/index";

const prisma = new PrismaClient()
const userRouter = express.Router();
const saltRounds = 10;

userRouter.post('/signup', async (req: Request, res: Response) => {
  /**
   * This regx is for validating password
   * (?=.*[a-z]) -> small letters
   * (?=.*[A-Z]) -> capital letters
   * (?=.*\d)    -> digits
   * (?=.*\W)    -> special characters
   * .{8,}        -> min length is 8 
  */
  const passRegx = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).{8,}$/;
  const emailRegx  = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/

  try {
    const reqData:{
      name: string,
      dob: Date | undefined,
      sex: string,
      email: string,
      password: string,
      contact: string | undefined,
      type: string
    } = req.body;
    
    if (reqData == undefined ||
      reqData.name == undefined ||
      reqData.email == undefined ||
      reqData.password == undefined ||
      reqData.type == undefined
    ) {
      res.status(400).send({
        error: 'Invalid request'
      });
      return;
    }

    if(!emailRegx.test(reqData.email)) {
      res.status(400).send({
        error: 'Invalid email',
        reqData
      });
      return;
    }

    const {count} = (await prisma.$queryRaw`
      SELECT COUNT(*)
      FROM client
      WHERE email = ${reqData.email.toLocaleLowerCase()}
    `as {count: number}[])[0];

    if (count != 0) {
      res.status(400).send({
        error: 'the email is already in use'
      });
      return;
    }

    if (!passRegx.test(reqData.password)) {
      res.status(400).send({
        error: 'Invalid password',
        reqData
      });
      return;
    }

    if (reqData.sex == undefined) {
      res.status(400).send({
        error: 'sex field not specified',
        reqData
      });
      return;
    }
    if (
      reqData.sex.toLowerCase() != "male" &&
      reqData.sex.toLowerCase() != "female" &&
      reqData.sex.toLowerCase() != "secrect"
    ) {
      res.status(400).send({
        error: 'Invalid sex',
        reqData
      });
      return;
    }

    if (reqData.type == undefined) {
      res.status(400).send({
        error: 'type field not specified',
        reqData
      });
      return;
    }

    const hashPass = await bcrypt.hash(reqData.password, saltRounds);

    const data = await prisma.client.create({
      data: {
        name: reqData.name,
        email: reqData.email.toLowerCase(),
        dob: reqData.dob,
        sex: reqData.sex,
        password: reqData.password,
        password_hash: Buffer.from(hashPass),
        contact: reqData.contact,
        type: reqData.type
      }
    });
    
    res.status(200).send({
      reqData,
      data,
      count: `${count}`,
      hashPass: hashPass
    });

  } catch(e) {
    res.status(500).send({
      error: 'something went wrong'
    });
    console.log(e);
    return;
  }
});

userRouter.post('/login', async (req: Request, res: Response) => {
  try {
    const reqData:{
      email: string,
      password: string
    } = req.body;

    if (reqData == undefined ||
      reqData.email == undefined ||
      reqData.password == undefined
    ) {
      res.status(400).send({
        error: 'Invalid request'
      });
      return;
    }

    const user = await prisma.client.findFirst({
      where: {
        email: reqData.email.toLowerCase()
      }
    });

    const result: boolean = await bcrypt.compare(reqData.password, user.password_hash.toString());

    if (result) {
      res.cookie("userToken", user.id);
      res.status(200).send({
        result: `${result}`
      });
    }else {
      res.status(401).send({
        error: "Invalid Password or email"
      });
    }

  }catch(e) {
    res.status(500).send({
      error: "something went wrong"
    });
    console.log(e);
  }
});

userRouter.use(userAuth);

userRouter.get('/', (req: Request, res: Response) => {
  res.status(200).send({
    msg: "working"
  });
});

export default userRouter;
