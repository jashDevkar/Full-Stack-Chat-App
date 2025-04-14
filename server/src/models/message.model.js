import mongoose from "mongoose";


const messageSchema = mongoose.Schema({
    senderEmail:{
        type:String,
    },
    recieverEmail:{
        type:String,
    },
    message:String,
    timeStamp:{
        type:Date,
        default:Date.now,
    }
});


const Message = mongoose.model("Message",messageSchema);

export default Message;