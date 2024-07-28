import express from 'express';

import * as Feature from '../controllers/features';
import { isLoggedIn } from '../middlewares/authorization';
import { uploadAudio } from '../config/storage';

export default (router: express.Router) => {
  router.get('/chats/:chatId', isLoggedIn, Feature.getChatHistory)
  router.post('/launch-assistant', isLoggedIn, Feature.launchHealthAssistant)
  router.post('/ask-health-assistant/:chatId', uploadAudio().single('symptomAudio'), isLoggedIn, Feature.healthAssistant);
}