import express from 'express';
import verifyUser from '../../middleware/verifyUser.js'
import sendFriendRequest from '../../controllers/chat/send-friend-request.controller.js';
import allFriendRequests from '../../controllers/chat/all-friend-requests.controller.js';


const chatRouter = express.Router();

chatRouter.post("/chat/send-friend-request",verifyUser,sendFriendRequest)
chatRouter.get("/chat/all-friend-requests",verifyUser,allFriendRequests)




export default chatRouter;