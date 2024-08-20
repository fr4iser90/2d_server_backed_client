// src/routes/authRoutes.js
const express = require('express');
const authController = require('../controllers/authController');
const router = express.Router();

router.post('/register', authController.register);  // Route für die Registrierung
router.post('/login', authController.login);        // Route für den Login
router.post('/logout', authController.logout);      // Route für den Logout

module.exports = router;
