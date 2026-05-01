# Simple Auth App

A simple login/signup application built with:
- **Frontend**: Vanilla HTML, CSS, JavaScript
- **Backend**: Node.js + Express
- **Database**: MySQL

---

## Project Structure

```
simple-auth-app/
├── frontend/
│   ├── index.html          # Welcome page
│   ├── login.html          # Login page
│   ├── signup.html         # Signup page
│   ├── css/styles.css      # Shared styles
│   └── js/
│       ├── auth.js         # Shared auth utilities
│       ├── login.js        # Login form logic
│       └── signup.js       # Signup form logic
├── backend/
│   ├── server.js           # Express entry point
│   ├── db.js               # MySQL connection pool
│   ├── routes/auth.js      # /api/login and /api/signup routes
│   ├── package.json
│   └── .env.example        # Environment variable template
└── README.md
```

---

## Prerequisites

- Node.js (v18+)
- MySQL (running locally or remotely)

---

## Setup

### 1. MySQL Database

Log into MySQL and create the database:

```sql
CREATE DATABASE simple_auth_db;
```

The `users` table is created automatically when the backend starts.

### 2. Backend

```bash
cd backend
npm install
```

Copy the environment file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env`:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=simple_auth_db
JWT_SECRET=some_long_random_secret_string
PORT=3000
```

Start the backend:

```bash
npm start
```

Or with auto-reload during development:

```bash
npm run dev
```

The server will run at `http://localhost:3000`.

### 3. Frontend

The frontend is plain HTML — no build step needed. Open it directly in your browser:

```bash
# Option A: just open the file
open frontend/index.html

# Option B: serve with a simple static server (recommended to avoid CORS issues with file://)
npx serve frontend
# Then open http://localhost:3000 (or the port shown)
```

> Note: The frontend makes API calls to `http://localhost:3000`. Make sure the backend is running before using the login/signup forms.

In frontend/js/auth.js  ..,, change the IP address of API_BASE to backend address
---

## API Endpoints

| Method | Endpoint      | Description        |
|--------|---------------|--------------------|
| POST   | /api/signup   | Register a new user |
| POST   | /api/login    | Login and get JWT  |
| GET    | /health       | Health check       |

### POST /api/signup

Request body:
```json
{ "name": "Jane Doe", "email": "jane@example.com", "password": "secret123" }
```

Response (201):
```json
{ "message": "Account created successfully." }
```

### POST /api/login

Request body:
```json
{ "email": "jane@example.com", "password": "secret123" }
```

Response (200):
```json
{
  "message": "Login successful.",
  "token": "<jwt>",
  "user": { "id": 1, "name": "Jane Doe", "email": "jane@example.com" }
}
```

---

## How It Works

1. Open `index.html` — welcome page with **Login** and **Sign Up** buttons in the top-right corner.
2. Click **Sign Up** → fill the form → account is created → redirected to login page.
3. Click **Login** → fill credentials → JWT token stored in `localStorage` → redirected to welcome page.
4. When logged in, the welcome page shows your name and a **Logout** button instead of auth buttons.
