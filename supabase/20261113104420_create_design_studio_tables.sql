
/*
# Create design studio backend tables

1. New Tables

- `contact_submissions` — stores messages submitted through the contact form
  - `id` (uuid, primary key)
  - `name` (text, not null) — submitter's name
  - `email` (text, not null) — submitter's email
  - `message` (text, not null) — the message body
  - `created_at` (timestamptz, defaults to now())

- `newsletter_subscribers` — stores email addresses from the newsletter signup
  - `id` (uuid, primary key)
  - `email` (text, unique, not null) — subscriber's email
  - `created_at` (timestamptz, defaults to now())

- `projects` — stores gallery/portfolio project entries
  - `id` (uuid, primary key)
  - `title` (text, not null) — project title
  - `category` (text, not null) — project category (Branding, Web Design, etc.)
  - `image_url` (text, not null) — URL to the project image
  - `created_at` (timestamptz, defaults to now())

2. Security

This is a single-tenant app with no sign-in screen. The frontend uses the anon key,
so all policies target `anon, authenticated`:

- `contact_submissions`: anyone can submit (INSERT) and read (SELECT) contact messages
- `newsletter_subscribers`: anyone can subscribe (INSERT) and check if email exists (SELECT)
- `projects`: anyone can read (SELECT) projects; no public insert/update/delete

RLS is enabled on all tables. Grants are scoped to the minimum verbs each role needs.
*/

-- Contact submissions table
CREATE TABLE IF NOT EXISTS contact_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  message text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT ON contact_submissions TO anon, authenticated;

DROP POLICY IF EXISTS "anon_select_contacts" ON contact_submissions;
CREATE POLICY "anon_select_contacts" ON contact_submissions FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_contacts" ON contact_submissions;
CREATE POLICY "anon_insert_contacts" ON contact_submissions FOR INSERT
  TO anon, authenticated WITH CHECK (true);

-- Newsletter subscribers table
CREATE TABLE IF NOT EXISTS newsletter_subscribers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT ON newsletter_subscribers TO anon, authenticated;

DROP POLICY IF EXISTS "anon_select_newsletter" ON newsletter_subscribers;
CREATE POLICY "anon_select_newsletter" ON newsletter_subscribers FOR SELECT
  TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "anon_insert_newsletter" ON newsletter_subscribers;
CREATE POLICY "anon_insert_newsletter" ON newsletter_subscribers FOR INSERT
  TO anon, authenticated WITH CHECK (true);

-- Projects table
CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  category text NOT NULL,
  image_url text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

GRANT SELECT ON projects TO anon, authenticated;

DROP POLICY IF EXISTS "anon_select_projects" ON projects;
CREATE POLICY "anon_select_projects" ON projects FOR SELECT
  TO anon, authenticated USING (true);
