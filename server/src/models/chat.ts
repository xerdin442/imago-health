import mongoose, { Schema, Document, Types } from "mongoose";

export interface IChat extends Document {
  user: Types.ObjectId
  history: { role: string, parts: [{ text: string }] }[]
}

const chatSchema = new Schema<IChat>({
  user: { type: Schema.Types.ObjectId, required: true },
  history: [{
    role: { type: String, required: true },
    parts: [{ text: { type: String, required: true } }]
  }]
})

export const Chat = mongoose.model<IChat>('Chat', chatSchema);