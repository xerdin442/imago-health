import { Request, Response } from 'express';
import { Types } from 'mongoose';

import * as Chat from '../services/chat';

export const createChat = async (req: Request, res: Response) => {
  try {
    const username = req.session.user.fullname.split(' ')[1]
    const userId = req.session.user._id as Types.ObjectId
    
    const chat = await Chat.createChat(username, userId)

    return res.status(200).json({ chatId: chat._id }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const checkSymptoms = async (req: Request, res: Response) => {
  try {
    const { chatId } = req.params
    if (!Types.ObjectId.isValid(chatId)) {
      return res.status(400).json({ message: "Error loading chat details; invalid chat ID provided" })
    }
  
    const { symptoms } = req.body
    if (symptoms) {
      await Chat.checkSymptomsFromTextInput(chatId, symptoms)
    }

    if (req.file) {
      await Chat.checkSymptomsFromFileInput(chatId, req.file)
    }

    return res.sendStatus(200)
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const getChatHistory = async (req: Request, res: Response) => {
  try {
    const { chatId } = req.params
    if (!Types.ObjectId.isValid(chatId)) {
      return res.status(400).json({ message: "Error loading chat details; invalid chat ID provided" })
    }

    const chatHistory = await Chat.getChatHistory(chatId)

    return res.status(200).json(chatHistory).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}