import User from '../../../models/user.model.js'
const allFriendRequests = async(req,res)=>{
    const userId = req.userId

    const user = await User.findById(userId).select("friendRequests").populate("friendRequests").lean()

    const friendRequests = user.friendRequests;


    const filteredFriendRequest = friendRequests.map((item)=>{
        delete item['sentFriendRequests']
        delete item['friends']
        delete item['friendRequests']
        delete item['password']
        delete item['__v']
        return item
    })

    


    res.json(filteredFriendRequest);
}


export default allFriendRequests