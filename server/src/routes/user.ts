import express from 'express';

import * as User from '../controllers/user';
import { upload } from '../config/storage';
import { handleValidationErrors, validateUpdateProfile } from '../middlewares/validation';

export default (router: express.Router) => {
  router.get('/users/:userId/profile', User.getProfile)
  router.put('/users/:userId/update-profile', upload('gemini-folder').single('profileImage'), validateUpdateProfile, handleValidationErrors, User.updateProfile)
  router.delete('/users/:userId/delete-account', User.deleteUser)

  // Medical records
  router.post('/records/create-record', User.createMedicalRecord)
  router.put('/records/:recordId/update-record', User.updateMedicalRecord)
}