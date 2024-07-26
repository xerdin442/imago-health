import { GoogleGenerativeAI } from "@google/generative-ai"
import { Types } from "mongoose"

import { Chat } from "../models/chat"
import { Record } from "../models/record"

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY)
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })

export const createChat = async (username: string, userId: Types.ObjectId) => {
  const record = await Record.findOne({ user: userId })
  const details = record.details

  const chat = new Chat({
    user: userId,
    history: [
      {
        role: "user",
        parts: [{ text: `Hello, my name is ${username}. Below is my medical information;
          Age: ${details.age}
          Gender: ${details.gender}
          Country: ${details.country}
          Allergies: ${details.allergies}
          Blood Group: ${details.bloodGroup}
          Terminal Illness: ${details.terminalIlless}
          Current Medications: ${details.currentMedications}
          Acute Illness: ${details.acuteIllness}
          Previous Surgeries: ${details.previousSurgery}`
        }],
      },
      {
        role: "model",
        parts: [{ text: "Great to meet you. How may I assist you today?" }],
      }
    ],
  })
  await chat.save()

  return chat
}

export const getChatHistory = async (chatId: string) => {
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }
  const history = chat.history.slice(2).map(chat => chat.parts[0].text)

  return history;
}

export const checkSymptomsFromTextInput = async (chatId: string, symptoms: string) => {
  const prompt: string = "Which illness do these symptoms indicate I may be suffering from?"

  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }

  const history = chat.history
  const response = model.startChat({ history })
  const result = await response.sendMessageStream([symptoms, prompt]);
  if (!result) {
    throw new Error('Error generating response')
  }
  
  let advice: string = ''
  for await (const chunk of result.stream) { advice += chunk }

  chat.history.push({
    role: "user",
    parts: [{ text: symptoms }]
  }, {
    role: "model",
    parts: [{ text: advice }]
  })
  await chat.save()
}

export const checkSymptomsFromFileInput = async (chatId: string, file: Express.Multer.File) => {
  const prompt: string = "Which illness do these symptoms indicate I may be suffering from?"
  const mimetypes: string[] = ['audio/wav', 'audio/mp3', 'audio/aiff', 'audio/aac', 'audio/ogg', 'audio/flac']

  const isValidFile = mimetypes.some(type => type === file.mimetype)
  if (!isValidFile) {
    throw new Error('Audio format is not supported')
  }

  const audioDescription = await model.generateContentStream([
    {
      fileData: {
        mimeType: file.mimetype,
        fileUri: file.path
      }
    },
    { text: "Generate a transcript of the speech" },
  ]);
  
  if (!audioDescription) {
    throw new Error('Error parsing information from audio')
  }

  let symptoms: string = ''
  for await (const chunk of audioDescription.stream) { symptoms += chunk }

  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }

  const history = chat.history
  const response = model.startChat({ history })
  const result = await response.sendMessageStream([symptoms, prompt]);
  if (!result) {
    throw new Error('Error generating response')
  }
  
  let advice: string = ''
  for await (const chunk of result.stream) { advice += chunk }

  chat.history.push({
    role: "user",
    parts: [{ text: file.path }]
  }, {
    role: "model",
    parts: [{ text: advice }]
  })
  await chat.save()
}