import express from 'express';
import verifyUser from '../../middleware/verifyUser.js'
import sendFriendRequest from '../../controllers/chat/friends/send-friend-request.controller.js';
import allFriendRequests from '../../controllers/chat/friends/all-friend-requests.controller.js';
import acceptFriendRequest from '../../controllers/chat/friends/accept-friend-request.controller.js';
import getAllFriends from '../../controllers/chat/friends/get-all-friends.controller.js';
import allChats from '../../controllers/chat/messages/all-chats.controller.js';
import sendMessage from '../../controllers/chat/messages/send-message.controller.js'


const chatRouter = express.Router();

chatRouter.post("/chat/send-friend-request",verifyUser,sendFriendRequest)
chatRouter.get("/chat/all-friend-requests",verifyUser,allFriendRequests)
chatRouter.post("/chat/accept-friend-request",verifyUser,acceptFriendRequest)
chatRouter.get("/chat/get-all-friends",verifyUser,getAllFriends)


chatRouter.get('/chat/messages/:email',verifyUser,allChats)
chatRouter.post('/chat/send-message/',sendMessage)





export default chatRouter;