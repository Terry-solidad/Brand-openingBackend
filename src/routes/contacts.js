const express = require('express');
const supabase = require('../supabaseClient');

const router = express.Router();

// GET /api/contacts — list all contact submissions
router.get('/', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('contact_submissions')
      .select('id, name, email, message, created_at')
      .order('created_at', { ascending: false });

    if (error) throw error;

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch contact submissions' });
  }
});

// POST /api/contacts — submit a new contact message
router.post('/', async (req, res) => {
  try {
    const { name, email, message } = req.body;

    if (!name || !email || !message) {
      return res.status(400).json({ error: 'Name, email, and message are required' });
    }

    const { data, error } = await supabase
      .from('contact_submissions')
      .insert([{ name, email, message }])
      .select('id, name, email, message, created_at')
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to submit contact message' });
  }
});

module.exports = router;
