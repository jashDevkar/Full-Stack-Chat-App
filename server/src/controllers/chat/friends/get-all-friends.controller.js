import path from "path";
import User from "../../../models/user.model.js";

const getAllFriends = async (req, res) => {
    try {
        const userId = req.userId;


        const friends = await User.findById(userId)
        .select('friends')
        .populate({path:'friends',select:'-password -friends -friendRequests -sentFriendRequests -__v'})
        .lean();

    


        


        return res.status(200).json(friends);


    } catch (error) {
        console.log(error);

        return res.status(404).json({message:`Error ${error}`});
    }




}



export default getAllFriends;