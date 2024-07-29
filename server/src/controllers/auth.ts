import { Request, Response } from 'express'
import bcrypt from 'bcryptjs'

import * as User from '../services/user'
import { sendEmail } from '../util/mail'

export const register = async (req: Request, res: Response) => {
  try {
    // Extract required fields from request body
    let { fullname, email, password, profileImage } = req.body

    /* Use a default image if user does not upload file
    Or set profileImage to path of stored image if user uploads file */
    if (!req.file) {
      profileImage = process.env.DEFAULT_IMAGE
    } else {
      profileImage = req.file.path
    }

    // If all the checks are successful, create a new user
    const hashedPassword = await bcrypt.hash(password, 12)
    const user = await User.createUser({
      email,
      fullname,
      password: hashedPassword,
      profileImage
    })

    req.session.user = user

    // Send success message if registration is complete
    return res.status(200).json({ message: 'Registration successful!', user: user }).end()
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}

export const login = async (req: Request, res: Response) => {
  try {
    const { email } = req.body // Extract required fields from request body

    const user = await User.getUserByEmail(email).select('+password')
    if (!user) {
      return res.status(200).json({ message: 'No user found with that email' })
    }

    // Check the entered password and send an error message if it is invalid
    const checkPassword = await bcrypt.compare(req.body.password, user.password)
    if (!checkPassword) {
      return res.status(200).json({ message: 'Invalid password' })
    }

    // If all checks are successful, configure session data for newly logged in user
    req.session.user = user

    return res.status(200).json({ message: 'Login successful!' }).end() // Send a success message if login is complete
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}

export const logout = (req: Request, res: Response) => {
  // Delete and reset session data before logout
  req.session.destroy((err) => {
    if (err) {
      // Log and send an error message if any server errors are encountered
      console.log(err)
      return res.sendStatus(500)
    }

    return res.status(200).json({ message: 'You logged out' })
  })
}

export const resetPassword = async (req: Request, res: Response) => {
  try {
    const { email } = req.body // Extract email from request body
    const token = Math.ceil(Math.random() * 10 ** 6) // Generate reset token that will be sent to the user

    // Find user by email address and return an error if not found
    const user = await User.getUserByEmail(email)
    if (!user) {
      return res.status(400).json({ message: 'User with that email does not exist' })
    }
  
    // If user check is successful, set the token, expiration time and save changes
    user.resetToken = token
    user.resetTokenExpiration = Date.now() + (3 * 60 * 60 * 1000)
    await user.save()
  
    await sendEmail(user) // Send reset token to the user's email address
    req.session.email = user.email // Save user's email address in a session incase the user requests for the token to be re-sent
  
    console.log(token)
    // Notify user that password reset token has been sent
    return res.status(200).json({ message: 'A reset token has been sent to your email' }).end()
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}

export const checkResetToken = async (req: Request, res: Response) => {
  try {
    const { resetToken } = req.body // Extract reset token from request body

    // Check if reset token is valid
    const user = await User.checkResetToken(resetToken)
    if (!user) {
      return res.status(400).json({ message: 'Invalid reset token' })
    }

    // Check if reset token has expired
    const currentTime = new Number(Date.now())
    if (user.resetTokenExpiration < currentTime) {
      return res.status(400).json({ message: 'The reset token has expired' })
    }

    // Reset token expiration time if the token is valid and save changes
    user.resetTokenExpiration = undefined
    await user.save()

    // Delete session created earlier for storing email and resending tokens
    req.session.destroy((err) => {
      if (err) { console.log(err) }
    })

    // Return redirect URL containing user's reset token
    const redirectURL = `https://imago-health.onrender.com/api/auth/change-password?resetToken=${user.resetToken}`
    
    return res.status(200).json({ redirectURL })
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}

export const resendToken = async (req: Request, res: Response) => {
  try {
    // Check if user exists with the email stored in session
    const user = await User.getUserByEmail(req.session.email)
    if (!user) {
      return res.status(400).json({ message: 'User not found' })
    }

    // Generate new reset token, reset the expiration time and save changes
    const token = Math.ceil(Math.random() * 10 ** 6)
    user.resetToken = token
    user.resetTokenExpiration = Date.now() + (3 * 60 * 60 * 1000)
    await user.save()

    await sendEmail(user) // Send email with new reset token to user

    console.log(token)
    // Notify user that password reset token has been re-sent
    return res.status(200).json({ message: 'Another token has been sent to your email' })
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}

export const changePassword = async (req: Request, res: Response) => {
  try {
    // Extract reset token from query paramters and new password from request body
    const { resetToken } = req.query
    const { password } = req.body
  
    const user = await User.checkResetToken(resetToken as string)
    if (!user) {
      return res.status(400).json({ message: 'Invalid reset token' }) // Send error message if reset token is invalid
    }
  
    // If reset token is valid, change password, reset the token value and save changes
    const hashedPassword = await bcrypt.hash(password, 12)  
    user.password = hashedPassword
    user.resetToken = undefined
    await user.save()
  
    // Notify user if password reset is successful
    return res.status(200).json({ message: 'Password has been reset' })
  } catch (error) {
    // Log and send an error message if any server errors are encountered
    console.log(error)
    return res.sendStatus(500)
  }
}