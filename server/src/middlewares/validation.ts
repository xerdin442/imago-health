import { check, ValidationChain, validationResult } from "express-validator";
import bcrypt from 'bcryptjs'
import { NextFunction, Request, Response } from "express";

import * as User from '../services/user'
import { deleteUpload } from "../config/storage";

export const validateSignup: ValidationChain[] = [
  check('fullname').trim()
    .isLength({ min: 5 }).withMessage('Fullname must be at least 5 characters')
    .isLength({ max: 50 }).withMessage('Fullname cannot be more than 50 characters'),

  check('email').normalizeEmail()
    .isEmail().withMessage('Please enter a valid email')
    .custom(async (value: string) => {
      const user = await User.getUserByEmail(value)
      if (user) {
        throw new Error('User with that email address already exists')
      }

      return true;
    }),

  check('password').trim()
    .isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),

  check('confirmPassword').trim()
    .custom(async (value: string, { req }) => {
      if (value !== req.body.password) {
        throw new Error('Passwords do not match!')
      }

      return true;
    })
]

export const validateLogin: ValidationChain[] = [
  check('email').normalizeEmail()
    .isEmail().withMessage('Please enter a valid email')
    .custom(async (value: string, { req }) => {
      // Check the email and send an error message if it does not exist
      const user = await User.getUserByEmail(value).select('+password')
      if (!user) {
        throw new Error('No user found with that email')
      }

      // Check the entered password and send an error message if it is invalid
      const checkPassword = await bcrypt.compare(req.body.password, user.password)
      if (!checkPassword) {
        throw new Error('Invalid password')
      }

      return true;
    })
]

export const validatePasswordReset: ValidationChain[] = [
  check('password').trim()
    .isLength({ min: 8 }).withMessage('Password must be at least 8 characters')
    .custom(async (value: string, { req }) => {
      const user = await User.checkResetToken(req.query.resetToken as string)
      const checkMatch = await bcrypt.compare(value, user.password)
      if (checkMatch) {
        throw new Error('New password cannot be set to same value as previous password')
      }

      return true;
    }),
]

export const validateUpdateProfile: ValidationChain[] = [
  check('fullname').trim()
    .isLength({ min: 5 }).withMessage('Fullname must be at least 5 characters')
    .isLength({ max: 50 }).withMessage('Fullname cannot be more than 50 characters'),

  check('email').normalizeEmail()
    .isEmail().withMessage('Please enter a valid email')
    .custom(async (value: string) => {
      const user = await User.getUserByEmail(value)
      if (user) {
        throw new Error('User with that email address already exists')
      }

      return true;
    }),
]

export const handleValidationErrors = (req: Request, res: Response, next: NextFunction) => {
  // Extract all validation errors, if any, and return the error message
  const errors = validationResult(req)
  if (!errors.isEmpty()) {
    const message = errors.array()[0].msg

    // Check for any uploaded image and delete from cloud storage
    if (req.file && req.file.path) {
      // Extract the public ID of the image from the file path
      const publicId = req.file.path.split('/').slice(-2).join('/').replace(/\.[^/.]+$/, "");

      deleteUpload(publicId) // Delete the uploaded image from Cloudinary
    }

    return res.status(422).json({ message })
  }

  next() // Proceed to next middleware if there are no errors
}