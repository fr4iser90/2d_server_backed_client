const mongoose = require('mongoose');

function db_middleware(req, res, next) {
    if (mongoose.connection.readyState !== 1) { // readyState 1 bedeutet verbunden
        return res.status(500).json({ error: 'Database connection lost' });
    }
    next();
}

module.exports = db_middleware;
