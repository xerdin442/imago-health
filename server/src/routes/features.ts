import express from 'express';

import * as Feature from '../controllers/features';
import { isLoggedIn } from '../middlewares/authorization';
import { upload } from '../config/storage';

export default (router: express.Router) => {
  router.post('/start-chat', isLoggedIn, Feature.createChat)
  router.post('/check-symptoms/:chatId', upload('gemini-folder').single('symptomAudio'), isLoggedIn, Feature.checkSymptoms)
  router.get('/chats/:chatId', isLoggedIn, Feature.getChatHistory)
}