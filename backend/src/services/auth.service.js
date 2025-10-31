import User from "../models/user.model.js";
import { hashPassword, comparePassword } from "../utils/hash.js";
import { signJWT } from "../utils/jwt.js";
import { toUserDTO } from "../dtos/user.dto.js";

/**
 * Register a new user
 */
export const register = async ({ name, email, password, deviceId }) => {
  // Check if user already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) throw { status: 400, message: "Email already registered" };

  // Hash password
  const hashedPassword = hashPassword(password);

  // Create user
  const user = await User.create({
    name,
    email,
    password: hashedPassword,
    devices: [{ deviceId, verified: false }],
  });

  // Return DTO (do NOT expose password)
  return { user: toUserDTO(user) };
};

/**
 * Login a verified user
 */

export const login = async ({ email, password, deviceId }) => {
  const user = await User.findOne({ email });
  if (!user) throw { status: 401, message: "Invalid credentials" };

  const match = comparePassword(password, user.password);
  if (!match) throw { status: 401, message: "Invalid credentials" };

  const device = user.devices.find(d => d.deviceId === deviceId);
  if (!device) throw { status: 401, message: "Device not registered" };

  switch (device.status) {
    case "REJECTED":
      throw { 
        status: 403, 
        message: `Device rejected: ${device.rejectionReason || "No reason provided"}` 
      };
    case "PENDING":
      throw { 
        status: 401, 
        message: "Device verification is pending. Please wait for admin approval." 
      };
    case "APPROVED":
      // device is approved, continue login
      break;
    default:
      throw { status: 401, message: "Device not verified yet" };
  }

  const token = signJWT({ id: user._id });
  return { token, user: toUserDTO(user) };
};

