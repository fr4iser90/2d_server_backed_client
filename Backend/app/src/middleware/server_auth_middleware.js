// src/middleware/server_auth_middleware.js

module.exports = (req, res, next) => {
    const server_key = req.headers['server-key'];  
    const valid_server_key = "your_server_key_here";  // Ersetze das mit deinem tatsächlichen Schlüssel

    if (server_key && server_key === valid_server_key) {
        // Authentifizierung erfolgreich, weiter zur nächsten Middleware/Funktion
        return next();
    } else {
        // Authentifizierung fehlgeschlagen, sende 401 Unauthorized
        return res.status(401).json({ message: 'Invalid server key' });
    }
};
