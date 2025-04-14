import User from "../../../models/user.model.js";
import Message from "../../../models/message.model.js";

const allChats = async(req,res)=>{
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


    
    
    
}


export default allChats