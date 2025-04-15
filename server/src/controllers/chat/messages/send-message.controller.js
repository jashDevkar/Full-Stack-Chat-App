import Message from "../../../models/message.model.js";

const sendMessage=async(req,res)=>{
  try{
    const {senderEmail,recieverEmail,text}=req.body;


    const message = new Message({
    senderEmail:senderEmail,
    recieverEmail:recieverEmail,
    message:text
    })

    message.save();

    res.status(200).json(message);
  }catch(e){
    console.log(e.toString());
    res.status(400).json({message:'Server error'});
  }
}


export default sendMessage;