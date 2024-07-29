import express from 'express';

import * as Feature from '../controllers/features';
import { uploadAudio } from '../config/storage';

export default (router: express.Router) => {
  router.get('/chats/:chatId', Feature.getChatHistory)
  router.post('/launch-assistant', Feature.launchHealthAssistant)
  router.post('/ask-health-assistant/:chatId', uploadAudio().single('symptomAudio'), Feature.healthAssistant);
}