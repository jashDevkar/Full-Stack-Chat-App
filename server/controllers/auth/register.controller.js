import User from "../../models/user.model.js"
import bcrypt, { hash } from 'bcryptjs';

const register = async(req, res) => {
    //collect json data
    const { name, email, password, image } = req.body;

    //hash password before storing it in database
    const hashedPassword = await bcrypt.hash(password, 8);

    //create a new user
    const newUser = new User({ name, email,password: hashedPassword, image });


    //save user to db
    newUser.save().then(() => {
        res.status(200).json({ message: "User registered successfully" });
    })
    .catch((err) => res.json({ error: err.message }));
}


export default register;