import { GoogleGenerativeAI } from "@google/generative-ai"

import { Newsletter } from "../models/newsletter";
import { newsletterPrompt } from "./prompts";

export const createLetter = async () => {
  try {
    // Initailize Google's generative AI model
    const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY)
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })
  
    // Generate a newsletter using the appropriate prompt
    const result = await model.generateContentStream(newsletterPrompt);
    if (!result) {
      throw new Error('Error generating newsletter')
    }
  
    // Extract the text content from the response stream
    let content: string = ''
    for await (const chunk of result.stream) { content += chunk.text() }
  
    // Create and save a newsletter document to the database
    const newsletter = new Newsletter({ content })
    await newsletter.save()

    console.log('Newsletter published successfully!')
  } catch (error) {
    console.log(error)
  }
}