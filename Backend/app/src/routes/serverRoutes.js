// src/routes/serverRoutes.js
const express = require('express');
const serverController = require('../controllers/serverController');
const passport = require('passport');

const router = express.Router();

// Middleware to authenticate the server (you can use custom logic or JWT, depending on your needs)
// In this example, we'll keep it simple and not use `passport` for server authentication, 
// but you can extend this with any security checks you need.
router.post('/authenticate', serverController.authenticateServer);

module.exports = router;
