import bcrypt from "bcryptjs";
import User from "../../models/user.model.js";
import jwt from 'jsonwebtoken';



/* 

accept user email and password 
check if user exist in database
if user exist, check if password is correct
if password is correct, create jwt token and send it back to client
if user does not exist or password is incorrect, send 401 request
if server error then send 500 request


*/


const login = async (req, res) => {
    try {
        const { email, password } = req.body;

    //    console.log("login request");
       
        const user = await User.findOne({ email });

        if (!user) {
            res.status(401).json({ message: "User doesn't exist" });
            return;
        }

        
        const { password: hashedPassword } = user
        const isPasswordCorrect = await bcrypt.compare(password, hashedPassword);


   
        if (!isPasswordCorrect) {
            res.status(401).json({ message: "Invalid credentials" });
            return;
        }

        const userData = {...user._doc}
        delete userData.password; //remove password from response
        delete userData.friendRequests;
        delete userData.friends;
        delete userData.sentFriendRequests;


        const token = createToken(user._id);
        res.status(200).json({ message: `${userData.name} you are now loged in!`, token ,...userData});



    } catch (e) {

        //server error
        res.status(500).json({ message: "Server error: "+e.message });
    }
}



//creating a jwt token
const createToken = (id) => {
    const payload = {
        userId: id
    }

    const token = jwt.sign(payload, "jaadu", { expiresIn: "30d" });
    return token;
}

export default login;