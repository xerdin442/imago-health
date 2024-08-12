import express from 'express';

import * as User from '../controllers/user';
import { isAuthenticated, isLoggedIn } from '../middlewares/authorization';
import { upload } from '../config/storage';
import { handleValidationErrors, validateUpdateProfile } from '../middlewares/validation';

export default (router: express.Router) => {
  router.get('/users/:userId/profile', isAuthenticated, User.getProfile)
  router.put('/users/:userId/update-profile', upload('gemini-folder').single('profileImage'), isAuthenticated, validateUpdateProfile, handleValidationErrors, User.updateProfile)
  router.delete('/users/:userId/delete-account', isAuthenticated, User.deleteUser)

  // Newsletter
  router.get('/newsletters', isLoggedIn, User.getAllLetters)
  router.get('/newsletters/:newsletterId', isLoggedIn, User.getLetter)
}