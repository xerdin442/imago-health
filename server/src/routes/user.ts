import express from 'express';

import * as User from '../controllers/user';
import { isAuthenticated } from '../middlewares/authorization';
import { upload } from '../config/storage';
import { handleValidationErrors, validateUpdateProfile } from '../middlewares/validation';

export default (router: express.Router) => {
  router.get('/users', User.getAll);
  router.get('/users/:userId/profile', isAuthenticated, User.getProfile)
  router.put('/users/:userId/update-profile', upload('project-manager').single('profileImage'), isAuthenticated, validateUpdateProfile, handleValidationErrors, User.updateProfile)
  router.delete('/users/:userId/delete-account', isAuthenticated, User.deleteUser)
}