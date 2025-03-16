import User from "../../models/user.model.js"
import bcrypt, { hash } from 'bcryptjs';
import jwt from 'jsonwebtoken';

const register = async(req, res) => {
    //collect json data
    const { name, email, password, image } = req.body;

    //check if user already exists
    const userExist = await User.findOne({ email });

    if(userExist) return res.status(400).json({ message: "User already exists" });


   

    //hash password before storing it in database
    const hashedPassword = await bcrypt.hash(password, 8);

    //create a new user
    const newUser = new User({ name, email,password: hashedPassword, image });


    // const id= newUser._id;
    
    //save user to db
    newUser.save().then(() => {
        const token = createToken(newUser._id);
        res.status(200).json({ message: "User registered successfully" ,token:token});
    })
    .catch((err) => res.json({ error: "Server Error: "+ err.message }));
}


const createToken = (id) => {
    const payload = {
        userId: id
    }

    const token = jwt.sign(payload, "jaadu", { expiresIn: "1h" });
    return token;
}


export default register;