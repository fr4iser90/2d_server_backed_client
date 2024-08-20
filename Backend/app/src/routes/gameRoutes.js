// src/routes/gameRoutes.js
const express = require('express');
const router = express.Router();
const gameController = require('../controllers/gameController');

router.get('/data', gameController.getGameData);

module.exports = router;
