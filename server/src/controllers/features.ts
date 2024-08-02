import { Request, Response } from 'express';
import { Types } from 'mongoose';

import * as Chat from '../services/chat';
import * as prompt from '../util/prompts';
import { IChat } from '../models/chat';

export const getChatHistory = async (req: Request, res: Response) => {
  try {
    const { chatId } = req.params
    if (!Types.ObjectId.isValid(chatId)) {
      return res.status(400).json({ message: "Error loading chat details; invalid chat ID provided" })
    }

    const chatHistory = await Chat.getChatHistory(chatId)

    return res.status(200).json({ chatHistory }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const launchHealthAssistant = async (req: Request, res: Response) => {
  try {
    const userId = req.session.user._id as Types.ObjectId
    const { symptoms, womensHealth, addiction, emergency, nonBinary } = req.query
    let chat: IChat;

    if (symptoms || womensHealth || addiction || emergency || nonBinary) {
      if (symptoms) {
        chat = await Chat.createChat(userId, prompt.symptomsCheckerPrompt)
      }
      if (womensHealth) {
        chat = await Chat.createChat(userId, prompt.womensHealthPrompt)
      }
      if (addiction) {
        chat = await Chat.createChat(userId, prompt.addictionPrompt)
      }
      if (emergency) {
        chat = await Chat.createChat(userId, prompt.emergencyResponsePrompt)
      }
      if (nonBinary) {
        chat = await Chat.createChat(userId, prompt.nonBinaryPrompt)
      }  
    } else {
      return res.status(400).json({ error: "Invalid query parameter provided" })
    }

    return res.status(200).json({ chatId: chat._id }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const healthAssistant = async (req: Request, res: Response) => {
  try {
    const { chatId } = req.params
    if (!Types.ObjectId.isValid(chatId)) {
      return res.status(400).json({ message: "Error loading chat details; invalid chat ID provided" })
    }
  
    const { userPrompt } = req.body
    const response = await Chat.continueChat(userPrompt, chatId)

    return res.status(200).json({ response }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}

export const drugVetting = async (req: Request, res: Response) => {
  try {
    const userId = req.session.user._id as Types.ObjectId
    const description = await Chat.drugVetting(userId, req.file)

    return res.status(200).json({ description }).end()
  } catch (error) {
    console.log(error)
    return res.sendStatus(500)
  }
}