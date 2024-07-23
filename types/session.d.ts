import 'express-session';

import { IUser } from '../src/models/user'

declare module 'express-session' {
  interface SessionData {
    user: IUser;
    email: string
  }
}
