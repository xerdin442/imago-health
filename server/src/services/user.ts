import { Record } from '../models/record';
import { User } from '../models/user';
import { Newsletter } from "../models/newsletter";

export const getUserById = (id: string) => {
  return User.findById(id)
}

export const getUserByEmail = (email: string) => {
  return User.findOne({ email });
}

export const createUser = async (values: Record<string, any>) => {
  const user = new User(values)
  if (!user) {
    throw new Error('An error occured while creating new user')
  }
  await user.save();
  
  return user.toObject();
}

export const updateProfile = (id: string, values: Record<string, any>) => {
  return User.findByIdAndUpdate(id, values, { new: true })
}

export const deleteUser = (id: string) => {
  return User.deleteOne({ _id: id });
}

export const checkResetToken = async (resetToken: string) => {
  return User.findOne({ resetToken }).select('+password')
}

export const createRecord = async (values: Record<string, any>) => {
  const record = new Record(values)
  if (!record) {
    throw new Error('An error occured while creating new user')
  }
  await record.save();
  
  return record.toObject();
}

export const updateRecord = async (id: string, values: Record<string, any>) => {
  return Record.findByIdAndUpdate(id, values, { new: true })
}

export const getAllLetters = async () => {
  return Newsletter.find()
}

export const getLetterById = async (id: string) => {
  return Newsletter.findById(id)
}