import { register, login } from "../services/auth.service.js";

export const registerController = async (req, res) => {
  try {
    const result = await register(req.body);
    res.status(201).json({data:result, message:"Registration successful!\nPlease wait for verification before logging in." });
  } catch (err) {
    res.status(err.status || 500).json({ message: err.message });
  }
};

export const loginController = async (req, res) => {
  try {
    const result = await login(req.body);
    res.status(200).json(result);
  } catch (err) {
    res.status(err.status || 500).json({ message: err.message });
  }
};
