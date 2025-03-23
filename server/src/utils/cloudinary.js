import {v2 as cloudinary} from 'cloudinary';
import fs from 'fs';
import dotenv from 'dotenv';


dotenv.config();



cloudinary.config({ 
    cloud_name: process.env.CLOUDINARY_NAME, 
    api_key: process.env.CLOUDINARY_API_KEY, 
    api_secret: process.env.CLOUDINARY_SECRET, // Click 'View API Keys' above to copy your API secret
});


const uploadOnCloudinary = async (filePath) => {
    try {
        console.log(filePath);
        if(!filePath) return null;
        const response = await cloudinary.uploader.upload(filePath,{
            resource_type: 'auto',
        });


        return response;
    } catch (error) {
        console.log(error);
        fs.unlink
        (filePath);
    }
    finally{
        fs.unlinkSync(filePath);
    }
}



export {uploadOnCloudinary}