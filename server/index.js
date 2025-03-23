import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import multer from'multer';
import passport from 'passport';
import localStrategy from 'passport-local';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import User from './src/models/user.model.js';
import Message from './src/models/message.model.js';
// import multer from 'multer';


import router from './src/routers/router.js';


dotenv.config();
const app = express();
const port = process.env.PORT || 8000




app.use(express.json())
app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }))
app.use(passport.initialize())
app.use(router);


///connect to mongoose
mongoose.connect(process.env.MONGOOSE_URL).then(()=>console.log('connected to mongoose')).catch((e)=>console.log("Error while connecting to db",e))


app.get('/', (req, res) => {
    res.send('Hello World');
})



///listen to server
app.listen(port,()=>{
    // console.log(url)
    console.log('Server is listening on port 8000');
})