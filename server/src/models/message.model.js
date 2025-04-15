import mongoose from "mongoose";


const messageSchema = mongoose.Schema({
    senderEmail:{
        type:String,
        required:true
    },
    recieverEmail:{
        type:String,
        required: true,
    },
    message:{
        type:String,
        required: true,
    },
    timeStamp:{
        type:Date,
        default:Date.now,
    }
});


const Message = mongoose.model("Message",messageSchema);

export default Message;