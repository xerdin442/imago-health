import mongoose, { Schema, Document, Types } from "mongoose";

export interface IUser extends Document {
  username: string
  email: string
  profileImage: string
  password: string
  resetToken?: number,
  resetTokenExpiration?: Number
}

const userSchema = new Schema<IUser>({
  username: { type: String, required: true },
  email: { type: String, required: true },
  profileImage: { type: String, required: true },
  password: { type: String, required: true, select: false },
  resetToken: { type: Number },
  resetTokenExpiration: { type: Number }
})

export const User = mongoose.model<IUser>('User', userSchema);