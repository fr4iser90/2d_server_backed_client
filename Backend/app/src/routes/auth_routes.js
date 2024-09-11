// src/routes/auth_routes.js
const express = require('express');
const auth_controller = require('../controllers/auth_controller');
const router = express.Router();

router.post('/register', auth_controller.register);  // Route für die Registrierung
router.post('/login', auth_controller.login);        // Route für den Login
router.post('/logout', auth_controller.logout);      // Route für den Logout

module.exports = router;
