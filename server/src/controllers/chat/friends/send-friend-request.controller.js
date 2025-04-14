import User from "../../../models/user.model.js";

const sendFriendRequest =async (req,res)=>{
    const {recieverId} = req.body

    const userId = req.userId;

    

    if(!recieverId  || !userId  || userId === recieverId  ){
        return res.status(401).json({message: "Unauthorized"});
    }

    const senderUser = await User.findByIdAndUpdate(userId, {$addToSet: {sentFriendRequests: recieverId}}, {new: true});
    const recieverUser = await User.findByIdAndUpdate(recieverId, {$addToSet: {friendRequests: userId}}, {new: true});
  
    const recieverData = {...recieverUser._doc};
 
    delete recieverData.password;


    

    if(!senderUser || !recieverUser  ){
        return res.status(404).json({message: "User not found"});
    }
    return res.status(201).json({message:'Request sended successfully',recieverData:recieverData} );
    
    
    
}



export default  sendFriendRequest;