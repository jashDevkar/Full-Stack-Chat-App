import { jwtDecode } from "jwt-decode";
import User from "../models/user.model.js";
import jwt from 'jsonwebtoken'

const verifyUser = async(req,res,next)=>{
    const token = req.headers['authorization'];


    try{
        const decodedToken = jwt.verify(token, 'jaadu');

        //user is verified 
        req.userId = decodedToken.userId;
        next();
    }
    catch(error){

        //user is not verified or expired
        res.status(401).json({message:"Token expired or invalid. Please log in again."});
        console.log(error);
        
    }

    
}



export default verifyUser;