import rateLimit from "express-rate-limit";

export const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 mins
  max: 3,
  message: "Too many requests, try again later",
});
