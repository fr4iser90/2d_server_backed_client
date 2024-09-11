// src/index.js
require('dotenv').config(); // Load .env file and set environment variables

const express = require('express');
const { apply_middleware, connect_database } = require('./middleware');
const db_middleware = require('./middleware/db_middleware');
const routes = require('./routes');

const app = express();
const PORT = process.env.APP_PORT || 3000;

apply_middleware(app); // Apply middleware

// Apply routes
app.use('/api', routes);

connect_database().then(() => {
    app.use(db_middleware); 
    app.listen(PORT, () => {
        console.log(`Express Server: Running on http://localhost:${PORT}`);
    });
});

