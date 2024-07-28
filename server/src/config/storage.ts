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
  const audioMimetypes: string[] = ['audio/wav', 'audio/mp3', 'audio/aiff', 'audio/aac', 'audio/ogg', 'audio/flac']
  const imageMimetypes: string[] = ['image/png', 'image/jpg', 'image/jpeg']

  const storage = new CloudinaryStorage({
    cloudinary: cloudinary,
    params: (req, file) => {
      const public_id = new Date().toISOString().replace(/:/g, '-') + '-' + file.originalname;
      
      if (audioMimetypes.some(type => type === file.mimetype)) {
        return {
          folder: folderName,
          public_id,
          resource_type: 'auto',
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
    if (audioMimetypes.some(type => type === file.mimetype) || imageMimetypes.some(type => type === file.mimetype)) {
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