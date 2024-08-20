// src/index.js
require('dotenv').config(); // .env-Datei laden und Umgebungsvariablen setzen

const express = require('express');
const { applyMiddleware, connectDatabase } = require('./middleware');
const dbMiddleware = require('./middleware/dbMiddleware');
const routes = require('./routes');

const app = express();
const PORT = process.env.APP_PORT || 3000;

applyMiddleware(app); // Middleware anwenden

// Routen anwenden
app.use('/api', routes);

connectDatabase().then(() => {
    app.use(dbMiddleware); 
    app.listen(PORT, () => {
        console.log(`Express Server: Running on http://localhost:${PORT}`);
    });
});
