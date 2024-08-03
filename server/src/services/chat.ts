import { GoogleGenerativeAI } from "@google/generative-ai"
import { Types } from "mongoose"
import axios from "axios";
import { Response } from "express";

import { Chat } from "../models/chat"
import { drugVettingPrompt } from "../util/prompts";

const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY)
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })

export const createChat = async (userId: Types.ObjectId, prompt: string) => {
  // Create a new chat and add the initial promppt to the conversation history
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

  return chat;
}

export const continueChat = async (symptoms: string, chatId: string) => {
  // Find chat by specified ID and throw an error if not found
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }

  // Sanitize the chat history for use by the model
  const chatHistory = chat.history.map(({ role, parts }) => ({
    role,
    parts: parts.map(part => ({
      text: part.text  // Extract only the text, excluding the auto-generated database IDs
    }))
  }));

  const response = model.startChat({ history: chatHistory }) // Populate the chat history of the conversation with the model
  const result = await response.sendMessageStream(symptoms); // Send a new message to the model
  if (!result) {
    throw new Error('Error generating response')
  }

  let advice: string = ''
  for await (const chunk of result.stream) { advice += chunk.text() } // Extract text content from the response stream

  // Add the symptoms and the model's response to the history of the current conversation
  chat.history.push({
    role: "user",
    parts: [{ text: symptoms }]
  }, {
    role: "model",
    parts: [{ text: advice }]
  })
  await chat.save()

  return advice; // Return the model's response
}

export const getChatHistory = async (chatId: string) => {
  // Find chat by specified ID and throw an error if not found
  const chat = await Chat.findById(chatId)
  if (!chat) {
    throw new Error('Chat details not found')
  }

  // Exclude the initial prompt to the model and return the remaining messages in the conversation
  const history = chat.history.slice(2).map(chat => chat.parts[0].text)

  return history;
}

export const drugVetting = async (userId: Types.ObjectId, file: Express.Multer.File, res: Response) => {
  // Converts local file information to a GoogleGenerativeAI.Part object.
  function fileToGenerativePart(buffer: string, mimeType: string) {
    return {
      inlineData: {
        data: buffer,
        mimeType
      },
    };
  }

  const response = await axios.get(file.path, { responseType: 'arraybuffer' }); // Download the image from cloudinary as a buffer
  const imageBuffer = Buffer.from(response.data, 'binary').toString("base64") // Convert image buffer to string format
  const imageParts = fileToGenerativePart(imageBuffer, file.mimetype) // Prepare the image for use by the model
  const prompt = await drugVettingPrompt(userId, res) // Generate the drug vetting prompt
  
  // Pass the image and prompt to the model and generate a response
  const result = await model.generateContent([prompt as string, imageParts]);
  if (!result) {
    throw new Error('Error generating response')
  }

  const description = result.response.text() // Extract the text from the model's response

  return description;
}