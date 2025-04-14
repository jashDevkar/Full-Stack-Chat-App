import User from "../../../models/user.model.js";
import jwt from 'jsonwebtoken';

const getUserData = async (req, res) => {
    const token = req.params.token;
    const decodedToken = jwt.decode(token);
    const user = await User.findById(decodedToken.userId);
    if (!user) {
        return res.status(404).json({ message: "No user exist" });
    }

    res.json(user);
}


export default getUserData;