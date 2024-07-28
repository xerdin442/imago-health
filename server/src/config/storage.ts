import { v2 as cloudinary } from "cloudinary";
import multer from "multer";
import { CloudinaryStorage } from "multer-storage-cloudinary";
import { Request } from "express";

// Cloudinary configuration
cloudinary.config({
  cloud_name: process.env.CLOUD_NAME,
  api_key: process.env.CLOUD_API_KEY,
  api_secret: process.env.CLOUD_API_SECRET,
  secure: true
});

export const upload = (folderName: string) => {
  const audioMimetypes: string[] = ['audio/mpeg',  // MP3
  'audio/mp3',
  'audio/wav',
  'audio/x-wav',
  'audio/aiff',
  'audio/x-aiff',
  'audio/aac',
  'audio/x-aac',
  'audio/ogg',
  'audio/flac',
  'audio/x-flac',
  'audio/mp4',
  'audio/x-m4a']
  const imageMimetypes: string[] = ['image/png', 'image/jpg', 'image/jpeg']

  const storage = new CloudinaryStorage({
    cloudinary: cloudinary,
    params: (req, file) => {
      console.log(file.path)
      const public_id = new Date().toISOString().replace(/:/g, '-') + '-' + file.originalname;
      
      if (audioMimetypes.includes(file.mimetype)) {
        return {
          folder: folderName,
          public_id,
          resource_type: 'video',
          bitrate: 32000 // Adjust the bitrate of the audio file to enhance processing
        };
      }
      
      return {
        folder: folderName,
        public_id,
        resource_type: 'image',
        transformation: [
          { width: 400, height: 400, crop: "limit", gravity: "center" } // Resize the image to fit within 400 x 400 pixels
        ]
      };
    }
  });

  const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
    if (audioMimetypes.includes(file.mimetype) || imageMimetypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(null, false);
    }
  };

  return multer({
    storage,
    limits: { fieldSize: 5 * 1024 * 1024 }, // Image sizes must be less than 5MB
    fileFilter
  });
};

export const deleteUpload = (publicId: string) => {
  cloudinary.uploader.destroy(publicId, (error, result) => {
    if (error) {
      console.error('Failed to delete image from Cloudinary:', error);
    } else {
      console.log('Image deleted from Cloudinary');
    }
  })
}