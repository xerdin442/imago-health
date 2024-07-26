import express from 'express';

import auth from './auth';
import user from './user';
import features from './features';

const router = express.Router()

export default (): express.Router => {
  auth(router)
  user(router)
  features(router)
  
  return router;
}