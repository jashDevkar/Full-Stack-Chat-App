import User from "../../models/user.model.js";
import jwt from 'jsonwebtoken';

const getAllUsers = async(req,res)=>{
    const token = req.params.token;
    const decodedData = jwt.decode(token);
    const users = await User.find({_id:{$ne:decodedData.userId}}).select("-password -__v ");
    
    
    res.json(users);
}


export default getAllUsers;