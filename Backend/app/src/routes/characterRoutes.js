// src/routes/characterRoutes.js
const express = require('express');
const characterController = require('../controllers/characterController');
const passport = require('passport');

const router = express.Router();

// Middleware zur Authentifizierung
const ensureAuthenticated = passport.authenticate('jwt', { session: false });

// Holt alle Charaktere eines Benutzers
router.get('/', ensureAuthenticated, characterController.getCharactersByUser);

// Erstellt einen neuen Charakter
router.post('/', ensureAuthenticated, characterController.createDefaultCharactersForUser);

// Aktualisiert die Position und Szene eines Charakters
router.put('/:characterId', ensureAuthenticated, characterController.updateCharacterState);

module.exports = router;
