import { Request, Response, NextFunction } from 'express'

export const isLoggedIn = (req: Request, res: Response, next: NextFunction) => {
  // Check if user object is available in session to confirm if user is logged in
  if (!(req.session.user)) {
    return res.status(401).json({ message: "You are not logged in" })
  }

  next()
}

export const isAuthenticated = (req: Request, res: Response, next: NextFunction) => {
  const { userId } = req.params

  // Check if there is a logged in user
  if (req.session.user) {
    // Check if the logged in user is the same as the user requesting to perform the operation
    if (req.session.user._id.toString() !== userId) {
      return res.status(401).json({ message: "Not authenticated to perform this operation" })
    }
  } else {
    return res.status(401).json({ message: "You are not logged in" })
  }

  next()
}