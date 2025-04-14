import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import cors from 'cors';
import multer from 'multer';
import passport from 'passport';
import localStrategy from 'passport-local';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import User from './src/models/user.model.js';
import Message from './src/models/message.model.js';
import { createServer } from 'node:http';
import router from './src/routers/router.js';
import chatRouter from './src/routers/chat/chat.router.js';
import { Server } from 'socket.io';
import { log } from 'node:console';

dotenv.config();

const app = express();
const port = process.env.PORT || 8000;
const server = createServer(app); 
const io = new Server(server, {
    cors: {
        origin: '*',
    },
});


const map = new Map();

// === Socket.IO Logic ===
io.on('connection', socket => {
    console.log('✅ New Socket Connected:', socket.id);

    socket.on('test_event', (data) => {
        console.log('📩 test_event received:', data);
        socket.emit('test_response', { message: 'Hello from server!' });
    });

    socket.on('register_user',(data)=>{
        // console.log('register user recieved',data);
        
        map.set(data.id,socket.id);
        console.log(map.entries());
        socket.emit('on_register_successfull',{'message':'User registered Successfully'});
    })

    socket.on('disconnect', () => {
        console.log('❌ Socket Disconnected:', socket.id);
    });
});


// === Express Middlewares ===
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(passport.initialize());

// === Routes ===
app.use(router);
app.use(chatRouter);
app.get('/', (req, res) => {
    res.send('Hello World');
});


// === DB Connection and Server Start ===
mongoose.connect(process.env.MONGOOSE_URL).then(() => {
    console.log('✅ Connected to MongoDB');
    server.listen(port, '0.0.0.0', () => {
        console.log(`🚀 Server and Socket.IO running on port ${port}`);
    });
}).catch((e) => console.error("❌ MongoDB connection error:", e));
