import express from 'express';

import * as Feature from '../controllers/features';
import { isLoggedIn } from '../middlewares/authorization';
import { upload } from '../config/storage';

export default (router: express.Router) => {
  router.get('/chats/:chatId', isLoggedIn, Feature.getChatHistory)
  router.post('/launch-assistant', isLoggedIn, Feature.launchHealthAssistant)
  
  router.post('/ask-health-assistant/:chatId', upload('gemini-folder').single('symptomAudio'), (req, res, next) => {
    console.log('Middleware reached');
    console.log('File:', req.file);
    console.log('Body:', req.body);
    next();
  }, isLoggedIn, Feature.healthAssistant);
  
}