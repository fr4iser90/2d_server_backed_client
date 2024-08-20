// src/middleware/index.js
const express = require('express');
const passport = require('passport');
const mongoose = require('mongoose');
require('../config/passport'); // Passport-Konfiguration laden

const applyMiddleware = (app) => {
    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use(express.static('public'));
    app.use(passport.initialize()); // Passport initialisieren
};

const connectDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log('MongoDB: Connected successfully');
    } catch (err) {
        console.error('MongoDB connection error:', err);
        process.exit(1); // Beende das Programm bei einem Verbindungsfehler
    }
};

module.exports = {
    applyMiddleware,
    connectDatabase
};
