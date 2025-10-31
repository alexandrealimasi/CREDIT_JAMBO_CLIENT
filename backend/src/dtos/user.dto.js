export const toUserDTO = (user) => ({
 id: user._id,
  name: user.name,
  email: user.email,
  balance: user.balance,
  devices: (user.devices || []).map((d) => ({
    deviceId: d.deviceId,
    verified: d.verified,
    status: d.status,
    rejectionReason: d.rejectionReason,
  })),
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});