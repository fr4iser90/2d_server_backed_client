// src/routes/character_routes.js
const express = require('express');
const character_controller = require('../controllers/character_controller');
const passport = require('passport');

const router = express.Router();

// Middleware zur Authentifizierung
const ensure_authenticated = passport.authenticate('jwt', { session: false });

// Holt alle Charaktere eines Benutzers
router.get('/', ensure_authenticated, character_controller.get_characters_by_user);

// Erstellt einen neuen Charakter
router.post('/', ensure_authenticated, character_controller.create_default_characters_for_user);

// Aktualisiert die Position und Szene eines Charakters
router.put('/:character_id', ensure_authenticated, character_controller.update_character_state);

// Character selected 
router.post('/select', ensure_authenticated, character_controller.select_character);

module.exports = router;
