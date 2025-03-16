import express from 'express';
import register from '../controllers/auth/register.controller.js';
import login from '../controllers/auth/login.controller.js';
import getAllUsers from '../controllers/chat/getAllUsers.controller.js';
import getUserData from '../controllers/chat/getUserData.controller.js';


const router  = express.Router();


router.post("/register",register);
router.post("/login",login);

router.get("/users/:token",getAllUsers);
router.get("/getUserData/:token",getUserData);




export default router;