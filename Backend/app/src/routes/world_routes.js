// routes/world_routes.js
const express = require('express');
const router = express.Router();
const { static_map, dynamic_map, player } = require('../models/world_model');

// Route to retrieve a static map
router.get('/static/:name', async (req, res) => {
    try {
        const map = await static_map.find_one({ name: req.params.name });
        if (!map) return res.status(404).send('Map not found');
        res.json(map);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route to generate and retrieve a dynamic map
router.post('/dynamic', async (req, res) => {
    try {
        const map = new dynamic_map(req.body);
        await map.save();
        res.json(map);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route to retrieve player status
router.get('/player/:id', async (req, res) => {
    try {
        const player = await player.find_one({ player_id: req.params.id });
        if (!player) return res.status(404).send('Player not found');
        res.json(player);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

module.exports = router;

