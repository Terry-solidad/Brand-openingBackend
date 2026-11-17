const express = require('express');
const cors = require('cors');
require('dotenv').config();

const contactsRouter = require('./src/routes/contacts');
const newsletterRouter = require('./src/routes/newsletter');
const projectsRouter = require('./src/routes/projects');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/contacts', contactsRouter);
app.use('/api/newsletter', newsletterRouter);
app.use('/api/projects', projectsRouter);

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Design Studio API running on port ${PORT}`);
});
