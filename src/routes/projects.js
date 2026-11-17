const express = require('express');
const supabase = require('../supabaseClient');

const router = express.Router();

// GET /api/projects — list all projects, optionally filtered by category
router.get('/', async (req, res) => {
  try {
    const { category } = req.query;

    let query = supabase
      .from('projects')
      .select('id, title, category, image_url, created_at')
      .order('created_at', { ascending: true });

    if (category && category.toLowerCase() !== 'all') {
      query = query.eq('category', category);
    }

    const { data, error } = await query;

    if (error) throw error;

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch projects' });
  }
});

// GET /api/projects/:id — get a single project
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const { data, error } = await supabase
      .from('projects')
      .select('id, title, category, image_url, created_at')
      .eq('id', id)
      .maybeSingle();

    if (error) throw error;

    if (!data) {
      return res.status(404).json({ error: 'Project not found' });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch project' });
  }
});

module.exports = router;
