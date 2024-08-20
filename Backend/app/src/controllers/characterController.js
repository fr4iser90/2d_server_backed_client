// src/controllers/characterController.js
const Character = require('../models/CharacterModel');

// Holt alle Charaktere für einen bestimmten Benutzer
exports.getCharactersByUser = async (req, res) => {
    try {
        const userId = req.user.id; // Angenommen, die Benutzer-ID kommt aus dem auth middleware
        console.log("Fetching characters for user ID:", userId);

        const characters = await Character.find({ user: userId });
        console.log(`User ${req.user.username} fetched characters:`, characters);

        res.json(characters);
    } catch (err) {
        console.error('Error fetching characters:', err);
        res.status(500).json({ message: 'Server error while fetching characters' });
    }
};

async function saveCorruptedData(userId, corruptedData) {
    try {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `corrupted_data_${userId}_${timestamp}.json`;
        const filepath = path.join(__dirname, '../corrupted_data/', filename);

        // Ordner erstellen, falls nicht vorhanden
        if (!fs.existsSync(path.join(__dirname, '../corrupted_data/'))) {
            fs.mkdirSync(path.join(__dirname, '../corrupted_data/'));
        }

        // Beschädigte Daten als JSON speichern
        fs.writeFileSync(filepath, JSON.stringify(corruptedData, null, 2));
        console.log('CORRUPTED DATA SAVED:', filepath);
    } catch (err) {
        console.error('Error saving corrupted data:', err);
        throw err;
    }
}

// Funktion zur Erstellung der Standardcharaktere
exports.createDefaultCharactersForUser = async (userId) => {
    const characters = [
        { name: 'Archer', class: 'Archer', user: userId },
        { name: 'Knight', class: 'Knight', user: userId },
        { name: 'Mage', class: 'Mage', user: userId }
    ];

    try {
        for (const charData of characters) {
            const character = new Character(charData);
            console.log("Creating character:", charData);
            await character.save();
            console.log("Character created:", character);
        }
    } catch (err) {
        console.error('Error creating default characters:', err);
        throw err;
    }
};

// Aktualisiert die Position und Szene eines Charakters
exports.updateCharacterState = async (req, res) => {
    try {
        const { characterId } = req.params;
        const { position, last_scene_path } = req.body;

        const character = await Character.findByIdAndUpdate(characterId, {
            position,
            last_scene_path,
        }, { new: true });

        if (!character) {
            return res.status(404).json({ message: 'Character not found' });
        }

        res.json(character);
    } catch (err) {
        console.error('Error updating character:', err);
        res.status(500).json({ message: 'Server error while updating character' });
    }
};
