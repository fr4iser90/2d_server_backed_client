// src/routes/index.js
const express = require('express');
const gameRoutes = require('./gameRoutes');
const userRoutes = require('./userRoutes');
const authRoutes = require('./authRoutes');
const utilityRoutes = require('./utilityRoutes'); 
const characterRoutes = require('./characterRoutes');
const serverRoutes = require('./serverRoutes'); 

const router = express.Router();

router.use('/game', gameRoutes);
router.use('/user', userRoutes);
router.use('/auth', authRoutes);
router.use('/utility', utilityRoutes);
router.use('/characters', characterRoutes);
router.use('/server', serverRoutes); 

module.exports = router;
