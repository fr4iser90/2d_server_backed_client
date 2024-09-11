// src/routes/server_routes.js
const express = require('express');
const server_controller = require('../controllers/server_controller');  
const server_auth_middleware = require('../middleware/server_auth_middleware');

const router = express.Router();

// Route zur Authentifizierung des Servers
router.post('/authenticate', server_controller.authenticate_server);

// Route zum Abrufen von Charakterdaten, geschützt durch die server_auth_middleware
router.post('/get_character', server_auth_middleware, server_controller.get_character_data);

module.exports = router;