// routes/worldRoutes.js
const express = require('express');
const router = express.Router();
const { StaticMap, DynamicMap, Player } = require('../models/worldModel');

// Route zum Abrufen einer statischen Karte
router.get('/static/:name', async (req, res) => {
    try {
        const map = await StaticMap.findOne({ name: req.params.name });
        if (!map) return res.status(404).send('Map not found');
        res.json(map);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route zum Generieren und Abrufen einer dynamischen Karte
router.post('/dynamic', async (req, res) => {
    try {
        const map = new DynamicMap(req.body);
        await map.save();
        res.json(map);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

// Route zum Abrufen des Spielerstatus
router.get('/player/:id', async (req, res) => {
    try {
        const player = await Player.findOne({ playerId: req.params.id });
        if (!player) return res.status(404).send('Player not found');
        res.json(player);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

module.exports = router;
