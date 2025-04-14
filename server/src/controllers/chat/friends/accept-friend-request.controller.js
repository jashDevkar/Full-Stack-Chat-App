import User from "../../../models/user.model.js";

const acceptFriendRequest = async (req, res) => {
  try {
    const userId = req.userId;
    const { recieverId } = req.body
    // console.log(recieverId);

    const user = await User.findByIdAndUpdate(userId, {
      $pull: { friendRequests: recieverId },
      $addToSet: { friends: recieverId }
    }, {
      new: true,

    }).select('friends sentFriendRequests friendRequests');

    const recieverUser = await User.findByIdAndUpdate(recieverId, {
      $pull: { friendRequests: userId },
      $addToSet: { friends: userId }
    }, {
      new: true,
    }).select('friends sentFriendRequests friendRequests');


    console.log(user,recieverUser);

    return res.status(200).json({ user: user, reciever: recieverUser });
  } catch (error) {
    return res.status(400).json({ message: `server error ${error}` })
  }



}


export default acceptFriendRequest