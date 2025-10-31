import express from "express";
import {
  deposit,
  withdraw,
  getBalance,
  getHistory
} from "../controllers/transaction.controller.js";

import { authMiddleware } from "../middlewares/auth.middleware.js";

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// POST /api/transactions/deposit
router.post("/deposit", deposit);

// POST /api/transactions/withdraw
router.post("/withdraw", withdraw);

// GET /api/transactions/balance
router.get("/balance", getBalance);

// GET /api/transactions/history
router.get("/history", getHistory);

export default router;
