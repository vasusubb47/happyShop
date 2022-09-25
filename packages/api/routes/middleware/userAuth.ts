
import express, {Request, Response, NextFunction} from 'express';

const userAuth = express.Router();

userAuth.get('/', (req: Request, res: Response, next: NextFunction) => {
  console.log("userAuth");
  next();
});

export default userAuth;
