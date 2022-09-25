
import { randomUUID } from 'crypto';
import express, {Request, Response, NextFunction} from 'express';
const { PrismaClient } = require('@prisma/client');

const userAuth = express.Router();
const prisma = new PrismaClient();

userAuth.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const {userToken}:{
      userToken: string
    } = req.cookies;
  
    const user = (await prisma.client.findFirst({
      where: {
        id: userToken
      },
      select: {
        name: true
      }
    }));
  
    if (user != undefined) {
      console.log("userAuth", user);
      next();
    }else {
      res.status(401).send({
        error: 'not valid cookie'
      });
    }
  } catch (err) {
    console.log(err);
    res.status(500).send({
      error: 'something went wrong'
    });
  }
});

export default userAuth;
