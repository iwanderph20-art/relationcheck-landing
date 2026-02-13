-- RelationCheck D1 Database Schema
-- Comprehensive relationship assessment platform

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  name TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Assessments table
CREATE TABLE IF NOT EXISTS assessments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  tier TEXT NOT NULL CHECK (tier IN ('essential', 'complete', 'premium')),
  partner_name TEXT,
  partner_email TEXT,
  partner_token TEXT UNIQUE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'user_completed', 'partner_completed', 'both_completed')),
  created_at TEXT NOT NULL,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Quiz responses table
CREATE TABLE IF NOT EXISTS quiz_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  assessment_id INTEGER NOT NULL,
  respondent_type TEXT NOT NULL CHECK (respondent_type IN ('user', 'partner')),
  question_id TEXT NOT NULL,
  answer INTEGER NOT NULL CHECK (answer >= 1 AND answer <= 5),
  created_at TEXT NOT NULL,
  FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE
);

-- Reports table
CREATE TABLE IF NOT EXISTS reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  assessment_id INTEGER NOT NULL UNIQUE,
  overall_score INTEGER CHECK (overall_score >= 0 AND overall_score <= 100),
  communication_score INTEGER CHECK (communication_score >= 0 AND communication_score <= 100),
  conflict_score INTEGER CHECK (conflict_score >= 0 AND conflict_score <= 100),
  trust_score INTEGER CHECK (trust_score >= 0 AND trust_score <= 100),
  intimacy_score INTEGER CHECK (intimacy_score >= 0 AND intimacy_score <= 100),
  partnership_score INTEGER CHECK (partnership_score >= 0 AND partnership_score <= 100),
  attachment_score INTEGER CHECK (attachment_score IS NULL OR (attachment_score >= 0 AND attachment_score <= 100)),
  values_score INTEGER CHECK (values_score IS NULL OR (values_score >= 0 AND values_score <= 100)),
  financial_score INTEGER CHECK (financial_score IS NULL OR (financial_score >= 0 AND financial_score <= 100)),
  growth_score INTEGER CHECK (growth_score IS NULL OR (growth_score >= 0 AND growth_score <= 100)),
  stress_score INTEGER CHECK (stress_score IS NULL OR (stress_score >= 0 AND stress_score <= 100)),
  family_score INTEGER CHECK (family_score IS NULL OR (family_score >= 0 AND family_score <= 100)),
  joy_score INTEGER CHECK (joy_score IS NULL OR (joy_score >= 0 AND joy_score <= 100)),
  recommendations TEXT,
  strengths TEXT,
  concerns TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (assessment_id) REFERENCES assessments(id) ON DELETE CASCADE
);

-- Indexes for performance optimization
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_assessments_user_id ON assessments(user_id);
CREATE INDEX IF NOT EXISTS idx_assessments_partner_token ON assessments(partner_token);
CREATE INDEX IF NOT EXISTS idx_quiz_responses_assessment_id ON quiz_responses(assessment_id);
CREATE INDEX IF NOT EXISTS idx_quiz_responses_assessment_respondent ON quiz_responses(assessment_id, respondent_type);
CREATE INDEX IF NOT EXISTS idx_reports_assessment_id ON reports(assessment_id);
