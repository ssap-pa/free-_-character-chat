-- Users table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE,
  password_hash TEXT,
  nickname TEXT NOT NULL DEFAULT 'Guest',
  char_name TEXT NOT NULL DEFAULT '자기',
  genres TEXT DEFAULT '[]',
  token_used INTEGER DEFAULT 0,
  token_limit INTEGER DEFAULT 10,
  is_guest INTEGER DEFAULT 1,
  created_at INTEGER DEFAULT (unixepoch() * 1000)
);

-- Sessions table (chat history)
CREATE TABLE IF NOT EXISTS sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  history TEXT NOT NULL DEFAULT '[]',
  updated_at INTEGER DEFAULT (unixepoch() * 1000),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
