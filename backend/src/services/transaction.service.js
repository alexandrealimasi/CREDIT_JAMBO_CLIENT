import User from "../models/user.model.js";
import Transaction from "../models/transaction.model.js";

export const deposit = async (userId, amount, note = "") => {
  const user = await User.findById(userId);
  user.balance += amount;
  await user.save();
  await Transaction.create({ userId, type: "deposit", amount, note });
  return user.balance;
};

export const withdraw = async (userId, amount, note = "") => {
  const user = await User.findById(userId);
  if (user.balance < amount) throw new Error("Insufficient balance");

  user.balance -= amount;
  await user.save();
  await Transaction.create({ userId, type: "withdraw", amount, note });
  return user.balance;
};

export const getHistory = async (userId) => {
  return await Transaction.find({ userId }).sort({ createdAt: -1 });
};

export const getBalance = async (userId) => {
  const user = await User.findById(userId);
  return user.balance;
};
