// src/routes/game_routes.js
const express = require('express');
const router = express.Router();
const game_controller = require('../controllers/game_controller');

router.get('/data', game_controller.get_game_data);

module.exports = router;
