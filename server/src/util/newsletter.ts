import { GoogleGenerativeAI } from "@google/generative-ai"

import { Newsletter } from "../models/newsletter";
import { newsletterPrompt } from "./prompts";

const createLetter = async () => {
  try {
    const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY)
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" })
  
    const result = await model.generateContentStream(newsletterPrompt);
    if (!result) {
      throw new Error('Error generating newsletter')
    }
  
    let content: string = ''
    for await (const chunk of result.stream) { content += chunk.text() }
  
    const newsletter = new Newsletter({ content })
    await newsletter.save()

    console.log('Newsletter published successfully!')
  } catch (error) {
    console.log(error)
  }
}

export const publishLetter = async () => {
  try {
    const weekDay = new Date().getDay()
    if (weekDay === 1 || weekDay === 5) {
      await createLetter()
    }
  } catch (error) {
    console.log(error)
  }
}