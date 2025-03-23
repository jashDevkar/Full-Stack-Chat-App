import User from "../../models/user.model.js"
import bcrypt, { hash } from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { uploadOnCloudinary } from '../../utils/cloudinary.js';

const register = async (req, res) => {
    //collect json data
    const { name, email, password } = req.body;

    //check if user already exists
    const userExist = await User.findOne({ email });

    if (userExist) return res.status(400).json({ message: "User already exists" });


    // console.log(req.file);
    const response = await uploadOnCloudinary(req.file.path);
    if (!response) return res.status(400).json({ message: "Failed to upload image" });

    const imageUrl = response.secure_url;



    //hash password before storing it in database
    const hashedPassword = await bcrypt.hash(password, 8);

    //create a new user
    const newUser = new User({ name, email, password: hashedPassword, imageUrl });


    //remove password from user object before sending it back to client (to prevent password leakage)
    const userData = { ...newUser._doc }
    delete userData.password;
    delete userData.friendRequests;
    delete userData.friends;
    delete userData.sentFriendRequests;

    //save user to db
    newUser.save().then(() => {
        const token = createToken(newUser._id);
        res.status(200).json({ message: "User registered successfully", token: token, ...userData });
    })
        .catch((err) => res.json({ error: "Server Error: " + err.message }));
}


const createToken = (id) => {
    const payload = {
        userId: id
    }

    const token = jwt.sign(payload, "jaadu", { expiresIn: "1h" });
    return token;
}


export default register;