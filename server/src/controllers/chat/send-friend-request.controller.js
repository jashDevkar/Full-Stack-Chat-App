import User from "../../models/user.model.js";

const sendFriendRequest =async (req,res)=>{
    const {recieverId} = req.body

    const userId = req.userId;

    console.log(userId, recieverId);

    if(!recieverId  || !userId  || userId === recieverId  ){
        return res.status(401).json({message: "Unauthorized"});
    }

    const senderUser = await User.findByIdAndUpdate(userId, {$addToSet: {sentFriendRequests: recieverId}}, {new: true});
    const recieverUser = await User.findByIdAndUpdate(recieverId, {$addToSet: {friendRequests: userId}}, {new: true});
  
    if(!senderUser || !recieverUser  ){
        return res.status(404).json({message: "User not found"});
    }
    return res.status(200).json({senderUser,recieverUser} );
    
    
    
}



export default  sendFriendRequest;