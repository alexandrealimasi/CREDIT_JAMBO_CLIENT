import request from "supertest";
import mongoose from "mongoose";
import app from "../app.js";
import User from "../models/user.model.js";
import Transaction from "../models/transaction.model.js";
import jwt from "jsonwebtoken";

let userToken;
let userId;

beforeAll(async () => {
  await mongoose.connect(process.env.MONGO_URI_TEST, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  await User.deleteMany({});
  await Transaction.deleteMany({});

  const user = await User.create({ name: "Transaction User", email: "tx@test.com", password: "123", deviceId: "dev1", deviceVerified: true });
  userId = user._id;

  userToken = jwt.sign({ id: user._id, role: "user" }, process.env.JWT_SECRET);
});

afterAll(async () => {
  await mongoose.connection.close();
});

describe("Transaction Operations", () => {
  it("should deposit amount", async () => {
    const res = await request(app)
      .post("/api/transactions/deposit")
      .set("Authorization", `Bearer ${userToken}`)
      .send({ amount: 500 });

    expect(res.statusCode).toBe(200);
    expect(res.body.balance).toBe(500);
  });

  it("should withdraw amount", async () => {
    const res = await request(app)
      .post("/api/transactions/withdraw")
      .set("Authorization", `Bearer ${userToken}`)
      .send({ amount: 200 });

    expect(res.statusCode).toBe(200);
    expect(res.body.balance).toBe(300);
  });

  it("should fetch transaction history", async () => {
    const res = await request(app)
      .get("/api/transactions/history")
      .set("Authorization", `Bearer ${userToken}`);

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.transactions)).toBe(true);
    expect(res.body.transactions.length).toBe(2);
  });
});
