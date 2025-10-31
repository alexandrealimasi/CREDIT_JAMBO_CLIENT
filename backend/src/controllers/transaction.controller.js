import * as transactionService from "../services/transaction.service.js";

export const deposit = async (req, res) => {
  const balance = await transactionService.deposit(req.user.id, req.body.amount, req.body.note);
  res.status(200).json({ message: "Deposit successful", balance });
};

export const withdraw = async (req, res) => {
  try {
    const balance = await transactionService.withdraw(req.user.id, req.body.amount, req.body.note);
    res.status(200).json({ message: "Withdrawal successful", balance });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

export const getHistory = async (req, res) => {
  const transactions = await transactionService.getHistory(req.user.id);
  res.json({ transactions });
};

export const getBalance = async (req, res) => {
  const balance = await transactionService.getBalance(req.user.id);
  res.json({ balance });
};
