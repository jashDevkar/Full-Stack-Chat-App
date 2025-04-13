import express from 'express';
import verifyUser from '../../middleware/verifyUser.js'
import sendFriendRequest from '../../controllers/chat/send-friend-request.controller.js';
import allFriendRequests from '../../controllers/chat/all-friend-requests.controller.js';
import acceptFriendRequest from '../../controllers/chat/accept-friend-request.controller.js';
import getAllFriends from '../../controllers/chat/get-all-friends.controller.js';


const chatRouter = express.Router();

chatRouter.post("/chat/send-friend-request",verifyUser,sendFriendRequest)
chatRouter.get("/chat/all-friend-requests",verifyUser,allFriendRequests)
chatRouter.post("/chat/accept-friend-request",verifyUser,acceptFriendRequest)
chatRouter.get("/chat/get-all-friends",verifyUser,getAllFriends)





export default chatRouter;