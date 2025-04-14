import express from 'express';
import register from '../controllers/auth/register.controller.js';
import login from '../controllers/auth/login.controller.js';
import getAllUsers from '../controllers/chat/data/get-all-users.controller.js';
import getUserData from '../controllers/chat/data/getUserData.controller.js';
import sendFriendRequest from '../controllers/chat/friends/send-friend-request.controller.js'
import { uploadOnCloudinary } from '../utils/cloudinary.js';
import upload from '../middleware/multer-upload.js';
import verifyUser from '../middleware/verifyUser.js';






const testController = async(req,res)=>{
    try{
        // console.log(req.file);
        const response = await uploadOnCloudinary(req.file.path);
        if(!response) return res.status(400).json({message: "Failed to upload image"});
        res.json({message: "Image uploaded successfully"});
    }
    catch(e){
        console.log(e); 
        
    }
    
}



const router  = express.Router();


router.post("/upload", upload.single('image'), testController);

router.post("/register",upload.single('image'),register);
router.post("/login",login);

router.get("/users/",verifyUser,getAllUsers);
router.get("/getUserData/:token",getUserData);





router.get("/",(req,res)=>{
    res.status(200).send("Hello World");
})




router.get("/send-request/:recipientId",sendFriendRequest)




export default router;