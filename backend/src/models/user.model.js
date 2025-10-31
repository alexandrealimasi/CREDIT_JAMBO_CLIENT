import mongoose from 'mongoose';

const DeviceSchema = new mongoose.Schema({
  deviceId: { type: String, required: true },
  verified: { type: Boolean, default: false },
  status: { 
    type: String, 
    enum: ['PENDING', 'REJECTED', 'APPROVED'], 
    default: 'PENDING' 
  },
  rejectionReason: { type: String, default: null },
  verifiedAt: { type: Date },
}, { _id: false });

const UserSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true, lowercase: true },
  password: { type: String, required: true },
  balance: { type: Number, default: 0 },
  devices: { type: [DeviceSchema], default: [] }
}, { timestamps: true });

export default mongoose.model('User', UserSchema);