import mongoose, { Schema, Document, Types } from "mongoose";

export interface INewsletter extends Document {
  content: string
}

const newsletterSchema = new Schema<INewsletter>({
  content: { type: String, required: true }
}, {
  timestamps: { createdAt: true, updatedAt: false }
})

export const Newsletter = mongoose.model<INewsletter>('Newsletter', newsletterSchema);