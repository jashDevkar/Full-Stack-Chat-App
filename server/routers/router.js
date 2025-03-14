import express from 'express';
import register from '../controllers/auth/register.controller.js';
import login from '../controllers/auth/login.controller.js';


const router  = express.Router();


router.post("/register",register);
router.post("/login",login);




export default router;