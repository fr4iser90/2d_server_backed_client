// src/controllers/serverController.js

exports.authenticateServer = (req, res) => {
    const { server_key } = req.body;

    // Validate the server key (this is a placeholder, replace it with your logic)
    const validServerKey = "your-server-key-here"; // This should match what your server sends

    if (server_key === validServerKey) {
        // If the server key is valid, send a success response
        res.status(200).json({ message: "Server authenticated successfully" });
    } else {
        // If the server key is invalid, send an unauthorized response
        res.status(401).json({ message: "Invalid server key" });
    }
};
