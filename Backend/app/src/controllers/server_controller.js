// src/controllers/serverController.js

const Character = require('../models/character_model'); 
const User = require('../models/user_model'); 

exports.authenticate_server = (req, res) => {
    const { server_key } = req.body;

    // Validate the server key (this is a placeholder, replace it with your logic)
    const valid_server_key = "your_server_key_here"; // This should match what your server sends

    if (server_key === valid_server_key) {
        // If the server key is valid, send a success response
        console.log("A Server Authentication Success")
        res.status(200).json({ message: "Server authenticated successfully" });
    } else {
        // If the server key is invalid, send an unauthorized response
        res.status(401).json({ message: "Invalid server key" });
    }
};

exports.get_character_data = async (req, res) => {
    const { user_id } = req.body;

    try {
        // Finde den Benutzer anhand der user_id
        const user = await User.findById(user_id).populate('selected_character').exec();

        if (!user || !user.selected_character) {
            return res.status(404).json({ message: "Character not found for this user" });
        }

        // Charakterdaten aus dem ausgewählten Charakter des Benutzers abrufen
        const character = user.selected_character;

        res.status(200).json({ result: character });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Error retrieving character data" });
    }
};