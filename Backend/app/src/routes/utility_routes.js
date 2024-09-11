// src/routes/utilityRoutes.js
const express = require('express');
const routeDiscoveryController = require('../controllers/route_discovery_controller');
const router = express.Router();

// /ping Route
router.get('/ping', (req, res) => {
    res.status(200).json({ message: 'Pong!' });
});

router.get('/get_all_routes', routeDiscoveryController.get_all_routes);

module.exports = router;
