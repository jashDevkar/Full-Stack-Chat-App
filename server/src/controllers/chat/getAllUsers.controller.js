import User from "../../models/user.model.js";
import jwt from 'jsonwebtoken';

const getAllUsers = async(req,res)=>{
    const token = req.headers['authorization'];
    const decodedData = jwt.decode(token);
    const allUsers = await User.find({_id:{$ne:decodedData.userId}}).select("-password -__v ");

    filteredUsers = allUsers.map(user=>{
        if(user.friends.includes(decodedData.userId) ){
            user.status = "Friends"
        }
        else if( user.friendRequests.includes(decodedData.userId) ){
            user.status = "Pending"
        }

    }); 
    
    
    res.json(allUsers);
}


export default getAllUsers;