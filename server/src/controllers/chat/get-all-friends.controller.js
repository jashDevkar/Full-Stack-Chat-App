import User from "../../models/user.model.js";

const getAllFriends = async (req, res) => {
    try {
        const userId = req.userId;


        const friends = await User.findById(userId).select('friends').populate().lean();


        console.log(friends);


        return res.status(200).json(friends);


    } catch (error) {
        console.log(error);

        return res.status(404).json({message:`Error ${error}`});
    }




}



export default getAllFriends;