import mongoose, { Schema, Document, Types } from "mongoose";

export interface IRecord extends Document {
  user: Types.ObjectId
  details: {
    age: number
    gender: string
    country: string
    allergies: string
    bloodGroup: string
    terminalIlless: string
    currentMedications: string
    acuteIllness: string
    previousSurgery: string
  }
}

const recordSchema = new Schema<IRecord>({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true},
  details: {
    age: { type: Number, required: true},
    gender: { type: String, required: true},
    country: { type: String, required: true},
    allergies: { type: String, required: true},
    bloodGroup: { type: String, required: true},
    terminalIlless: { type: String, required: true},
    currentMedications: { type: String, required: true},
    acuteIllness: { type: String, required: true},
    previousSurgery: { type: String, required: true}
  }
})

export const Record = mongoose.model<IRecord>('Record', recordSchema);