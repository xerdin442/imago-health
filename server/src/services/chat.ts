import { GoogleGenerativeAI } from "@google/generative-ai"
import { Types } from "mongoose"
import fs from 'fs'
import path from "path";

import { Chat } from "../models/chat"

const genAI = new GoogleGenerativeAI('AIzaSyBaKaioMRVz-dwagdtapR3j08vpt7Mwkqo')
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })

export const createChat = async (userId: Types.ObjectId, prompt: string) => {
  const chat = new Chat({
    user: userId,
    history: [
      {
        role: "user",
        parts: [{ text: prompt }],
      },
      {
        role: "model",
        parts: [{ text: "Great, I'll be glad to help!" }],
      }
    ],
  })
  await chat.save()

  return chat
}

export const continueChat = async (symptoms: string, chatId: string) => {
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }

  const chatHistory = chat.history.map(({ role, parts }) => ({
    role,
    parts: parts.map(part => ({
      text: part.text  // Extract only the text, excluding the auto-generated database IDs
    }))
  }));

  const response = model.startChat({ history: chatHistory })
  const result = await response.sendMessageStream(symptoms);
  if (!result) {
    throw new Error('Error generating response')
  }

  let advice: string = ''
  for await (const chunk of result.stream) { advice += chunk.text() }

  chat.history.push({
    role: "user",
    parts: [{ text: symptoms }]
  }, {
    role: "model",
    parts: [{ text: advice }]
  })
  await chat.save()
}

export const getChatHistory = async (chatId: string) => {
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }
  const history = chat.history.slice(2).map(chat => chat.parts[0].text)

  return history;
}

export const drugVetting = async (userId: Types.ObjectId) => {
  // Converts local file information to a GoogleGenerativeAI.Part object.
  function fileToGenerativePart(path: string, mimeType: string) {
    return {
      inlineData: {
        data: Buffer.from(fs.readFileSync(path)).toString("base64"),
        mimeType
      },
    };
  }

  const filePath = path.join(__dirname, '../', 'images/drugImage')
  const mimeType = 'image/png' || 'image/jpg' || 'image/jpeg'
  const imageParts = fileToGenerativePart(filePath, mimeType)
  const prompt = 'Identify and describe the drug in the image. State its content, functions and side-effects, if any.'
  
  const result = await model.generateContentStream([prompt, imageParts]);
  if (!result) {
    throw new Error('Error generating response')
  }

  let description: string = ''
  for await (const chunk of result.stream) { description += chunk.text() }

  const chat = new Chat({
    user: userId,
    history: [
      {
        role: "model",
        parts: [{ text: description }],
      }
    ],
  })
  return await chat.save()
}

export const getDrugDescription = async (chatId: string) => {
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }
  const history = chat.history[0].parts[0].text

  return history;
}