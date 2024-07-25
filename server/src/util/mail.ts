import axios from 'axios';

import { IUser } from '../models/user';

export const sendEmail = async (receiver: IUser) => {
  const url = 'https://api.brevo.com/v3/smtp/email'; // Transactional email endpoint

  const data = {
    sender: {
      name: 'Project Manager',
      email: 'mudianthonio27@gmail.com',
    },
    to: [
      {
        email: `${receiver.email}`,
        name: `${receiver.fullname}`,
      },
    ],
    // Subject and content of the email
    subject: 'Password Reset',
    htmlContent: `
    <p>Hello ${receiver.fullname.split(' ')[1]},</p>
    <h1>${receiver.resetToken}</h1>
    <p>You requested for a password reset. This code expires in <b>3 hours.</b></p>
    <p>If this wasn't you, please ignore this email.</p>
    `
  };

  try {
    const response = await axios.post(url, data, {
      // Set the headers of the request
      headers: {
        'accept': 'application/json',
        'api-key': process.env.BREVO_API_KEY,
        'content-type': 'application/json',
      },
    });
    console.log('Email sent successfully:', response.data);
  } catch (error) {
    console.error('Error sending email:', error);
  }
}