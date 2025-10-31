# Credit Jambo Ltd – Client Application

Client Application for the **Savings Management System** at Credit Jambo Ltd.
This app allows customers to register, log in, deposit, withdraw, and view their account balance and transaction history. Mobile users receive notifications for deposits, withdrawals, low balance, and device verification.

---

## Table of Contents

* [Features](#features)
* [Tech Stack](#tech-stack)
* [Project Structure](#project-structure)
* [Installation](#installation)
* [Environment Variables](#environment-variables)
* [Usage](#usage)
* [License](#license)

---

## Features

* **Customer Authentication** – Registration & Login with JWT-secured sessions
* **Device Verification** – Only approved devices can log in
* **Deposit & Withdraw** – Perform transactions safely, prevent overdrafts
* **Balance & History** – View current balance and detailed transaction history
* **Notifications** – Alerts for deposits, withdrawals, low balance, device verification
* **Responsive UI** – Mobile-first design with Flutter (or Web version)
* **Loader & Feedback** – Visual feedback for API calls and actions

---

## Tech Stack

* **Frontend:** Flutter (or React.js Web)
* **Backend:** Node.js, Express.js, MongoDB
* **Authentication:** JWT
* **State Management:** Provider, Riverpod, or Redux
* **Notifications:** Firebase Cloud Messaging (for mobile)
* **HTTP Client:** Dio or Axios

---

## Project Structure

```
frontend/
├── lib/ (Flutter) or src/ (Web)
│   ├── components/ # Reusable UI widgets
│   ├── pages/      # Screens / Pages
│   ├── services/   # API calls
│   ├── providers/  # State management
│   └── utils/      # Helpers, constants
├── assets/
├── pubspec.yaml (Flutter) or package.json (Web)
└── README.md

backend/
├── src/
│   ├── controllers/
│   ├── services/
│   ├── models/
│   ├── dtos/
│   ├── middlewares/
│   └── utils/
├── tests/
├── package.json
└── server.js
```

---

## Installation

### Prerequisites

* Node.js >= 18
* npm or yarn
* Flutter SDK (for mobile version)

### Backend Setup

```bash
# Clone repository
git clone <repo-url>
cd backend

# Install dependencies
npm install

# Create a .env file
cp .env.example .env
# Edit .env with your MongoDB URL, JWT secret, etc.

# Start server
npm run dev
```

### Frontend Setup (Flutter)

```bash
cd frontend
flutter pub get

# Load environment variables
flutter_dotenv

# Run app
flutter run
```

---

## Environment Variables

**Backend (.env example)**

```
PORT=5000
MONGO_URI=mongodb://localhost:27017/credit-jambo
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d
```

**Frontend (.env)**

```
BASEURL=http://localhost:5000/api
```

---

## Usage

1. Open the app and register as a customer.
2. Log in with your credentials.
3. Only verified devices can log in; pending devices will show a waiting message.
4. Deposit or withdraw money safely.
5. Check your balance and transaction history.
6. Receive notifications for deposits, withdrawals, or low balance alerts.


## License

MIT License © 2025 Credit Jambo Ltd

