import { Request, Response } from 'express';
import { Types } from 'mongoose';

import * as User from '../services/user';

export const getProfile = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params
    if (!Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ message: "Invalid user ID" })
    }
    
    const user = await User.getUserById(userId)
    if (!user) {
      return res.status(400).json({ message: "An error occured while fetching user details" })
    }

    return res.status(200).json({ user }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const updateProfile = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params
    if (!Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ message: "Invalid user ID" })
    }

    const { fullname, email } = req.body
    let profileImage;

    if (req.file) {
      profileImage = req.file.path
    }

    const user = await User.updateProfile(userId, { fullname, email, profileImage })
    if (!user) {
      return res.status(400).json({ message: "An error occured while creating new user" })
    }
  
    return res.status(200).json({ user }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500) 
  }
}

export const deleteUser = async (req: Request, res: Response) => {
  try {
    const { userId } = req.params
    if (!Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ message: "Invalid user ID" })
    }

    await User.deleteUser(userId)

    return res.status(200).json({ message: 'User successfully deleted' }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const getAllLetters = async (req: Request, res: Response) => {
  try {
    const newsletters = await User.getAllLetters()
    if (!newsletters) {
      return res.status(400).json({ message: "An error occured while retreiving all newsletters" })
    }

    return res.status(200).json({ newsletters }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const getLetter = async (req: Request, res: Response) => {
  try {
    const { newsletterId } = req.params
    if (!Types.ObjectId.isValid(newsletterId)) {
      return res.status(400).json({ message: "Invalid newsletter ID" })
    }
    
    const newsletter = await User.getLetterById(newsletterId)
    if (!newsletter) {
      return res.status(400).json({ message: "An error occured while fetching newsletter" })
    }

    return res.status(200).json({ newsletter }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}