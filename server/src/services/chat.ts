import { GoogleGenerativeAI } from "@google/generative-ai"
import { GoogleAIFileManager } from "@google/generative-ai/server";
import { Types } from "mongoose"

import { Chat } from "../models/chat"

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY)
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })
const fileManager = new GoogleAIFileManager(process.env.API_KEY);

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

export const checkSymptomsFromAudioInput = async (chatId: string) => {
  const audioFile = await fileManager.uploadFile('../audio/symptoms', { mimeType: 'audio/x-acc' || 'audio/acc' })

  const audioDescription = await model.generateContentStream([
    {
      fileData: {
        mimeType: audioFile.file.mimeType,
        fileUri: audioFile.file.uri
      }
    },
    { text: "Generate a transcript of the speech" },
  ]); 
  if (!audioDescription) {
    throw new Error('Error parsing information from audio')
  }

  let symptoms: string = ''
  for await (const chunk of audioDescription.stream) { symptoms += chunk.text() }

  return await continueChat(symptoms, chatId)
}