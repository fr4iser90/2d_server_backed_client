// src/routes/user_routes.js
const express = require('express');
const router = express.Router();
const user_controller = require('../controllers/user_controller');

router.get('/data', user_controller.get_user_data);

module.exports = router;
