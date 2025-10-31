import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";

// Import routes
import authRoutes from "./routers/auth.routes.js";
import transactionRoutes from "./routers/transaction.routes.js";
import { limiter } from "./middlewares/rateLimiter.js";

const app = express();

// --- Middleware ---
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));

// --- Routes ---
// Apply rate limiter only to auth routes
app.use("/api/auth", limiter, authRoutes);

// Transactions and other routes without rate limiter
app.use("/api/transactions", transactionRoutes);

// --- Health Check ---
app.get("/", (req, res) => {
  res.send("Credit Jambo Mobile API is running 🚀");
});

export default app;
