// src/routes/index.js
const express = require('express');
const game_routes = require('./game_routes');
const user_routes = require('./user_routes');
const auth_routes = require('./auth_routes');  // Updated to snake_case
const utility_routes = require('./utility_routes'); 
const character_routes = require('./character_routes');
const server_routes = require('./server_routes'); 

const router = express.Router();

router.use('/game', game_routes);
router.use('/user', user_routes);
router.use('/auth', auth_routes);  // Updated to snake_case
router.use('/utility', utility_routes);
router.use('/characters', character_routes);
router.use('/server', server_routes); 

module.exports = router;
