import User from "../../../models/user.model.js";
import Message from "../../../models/message.model.js";
import { error } from "node:console";

const allChats = async(req,res)=>{
   try{
    const recieverEmail = req.params.email;
    const userId = req.userId


    const user = await User.findById(userId).select("email").lean()

    const senderEmail = user.email;

    const messages = await Message.find({
        $or: [
          { senderEmail: senderEmail, recieverEmail: recieverEmail },
          { senderEmail: recieverEmail, recieverEmail: senderEmail }
        ]
      }).sort({ timeStamp: 1 }); 

    return res.status(200).json(messages);
   }catch(e){
    
    console.log(error.toString());
    return res.status(400).json({message:'Error occured'})
   }

    
    
    
}


export default allChats