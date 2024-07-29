import express from 'express';

import * as Feature from '../controllers/features';
import { isLoggedIn } from '../middlewares/authorization';
import { uploadDrug } from '../config/storage';

export default (router: express.Router) => {
  router.get('/chats/:chatId', isLoggedIn, Feature.getChatHistory)
  
  router.post('/launch-assistant', isLoggedIn, Feature.launchHealthAssistant)
  router.post('/ask-health-assistant/:chatId', isLoggedIn, Feature.healthAssistant);

  router.post('/drug-vetting', uploadDrug().single('drugImage'), isLoggedIn, Feature.drugVetting);
  router.post('/get-drug-description/:chatId', isLoggedIn, Feature.getDrugDescription);
}