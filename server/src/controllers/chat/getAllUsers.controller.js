import User from "../../models/user.model.js";
import jwt from 'jsonwebtoken';

const getAllUsers = async (req, res) => {
    try {
        const userId = req.userId


        const allUsers = await User.find({ _id: { $ne: userId } }).select("-password -__v ").lean();

        if(!allUsers){
            console.log('no users');
            return res.status(404).json({ message: "No user found" });
        }


        const filteredUser = allUsers.map(item => {

            const friends = JSON.stringify(item.friends)
            const filteredFriends = JSON.parse(friends);

            if (filteredFriends.includes(userId)) {
                item.status = 'Friends'
                return item
            }

            const friendRequests = JSON.stringify(item.friendRequests)
            const filteredFriendRequests = JSON.parse(friendRequests);

            if (filteredFriendRequests.includes(userId)) {
                item.status = 'Pending'
                return item
            }

            const sentFriendRequests = JSON.stringify(item.sentFriendRequests)
            const filteredSentFriendRequests = JSON.parse(sentFriendRequests);


            

            if (filteredSentFriendRequests.includes(userId)) {
            
                item.status = 'Accept'
                return item
            }

            item.status = 'Add friend'
            return item


        }).map((item) => {
            delete item.password;
            delete item.friendRequests;
            delete item.friends;
            delete item.sentFriendRequests;
            return item;
        })


        res.status(200).json(filteredUser);
    } catch (error) {
        return res.status(400).json({message:'Server error'});
    }
}


export default getAllUsers;