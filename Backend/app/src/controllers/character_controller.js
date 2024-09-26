const mongoose = require('mongoose');
const Character = require('../models/character_model');
const User = require('../models/user_model');


// Holt alle Charaktere für einen bestimmten Benutzer
exports.get_characters_by_user = async (req, res) => {
    try {
        const user_id = req.user.id; // Angenommen, die Benutzer-ID kommt aus dem Auth Middleware
        console.log("Fetching characters for user ID:", user_id);

        // Fetch characters for the user, no need to populate denormalized fields
        const characters = await Character.find({ user: user_id })
            .populate('inventory') // still a reference
            .populate('crafting_materials') // still a reference
            .populate('stash'); // still a reference

        console.log(`User ${req.user.username} fetched characters:`, characters);

        res.json(characters);
    } catch (err) {
        console.error('Error fetching characters:', err);
        res.status(500).json({ message: 'Server error while fetching characters' });
    }
};

async function save_corrupted_data(user_id, corrupted_data) {
    try {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `corrupted_data_${user_id}_${timestamp}.json`;
        const filepath = path.join(__dirname, '../corrupted_data/', filename);

        // Ordner erstellen, falls nicht vorhanden
        if (!fs.existsSync(path.join(__dirname, '../corrupted_data/'))) {
            fs.mkdirSync(path.join(__dirname, '../corrupted_data/'));
        }

        // Beschädigte Daten als JSON speichern
        fs.writeFileSync(filepath, JSON.stringify(corrupted_data, null, 2));
        console.log('CORRUPTED DATA SAVED:', filepath);
    } catch (err) {
        console.error('Error saving corrupted data:', err);
        throw err;
    }
}

// Funktion zur Erstellung der Standardcharaktere
exports.create_default_characters_for_user = async (user_id) => {
    const characters = [
        { name: 'Archer', character_class: 'Archer', user: user_id },
        { name: 'Knight', character_class: 'Knight', user: user_id },
        { name: 'Mage', character_class: 'Mage', user: user_id }
    ];

    try {
        for (const char_data of characters) {
            const character = new Character(char_data);
            console.log("Creating character:", char_data);
            await character.save();
            console.log("Character created:", character);
        }
    } catch (err) {
        console.error('Error creating default characters:', err);
        throw err;
    }
};

// Aktualisiert die Position und Szene eines Charakters
exports.update_character_state = async (req, res) => {
    try {
        const { character_id } = req.params;
        const { position, last_scene_path } = req.body;

        const character = await Character.findByIdAndUpdate(character_id, {
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

exports.select_character = async (req, res) => {
    try {
        console.log("select_character route called");

        const user_id = req.user.id;  // Authentifizierter Benutzer
        console.log("User ID:", user_id);

        const { character_id } = req.body;

        // Validierung
        if (!character_id) {
            console.log("No character ID provided");
            return res.status(400).json({ message: 'Character ID is required' });
        }

        // Charakter abrufen und verknüpfte Daten laden
        const character = await Character.findOne({ _id: character_id, user: user_id })             
        .populate('inventory')           
        .populate('crafting_materials')  
        .populate('stash');              

        if (!character) {
            console.log("Character not found or does not belong to the user");
            return res.status(404).json({ message: 'Character not found or does not belong to the user' });
        }

        console.log("Character found:", character);

        // Benutzerinformationen aktualisieren (ausgewählter Charakter)
        const user = await User.findById(user_id);
        if (!user) {
            console.log("User not found");
            return res.status(404).json({ message: 'User not found' });
        }
        
        user.selected_character = character_id;
        await user.save();

        console.log(`User ${user.username} selected character:`, character);
        res.json({ message: 'Character selected successfully', character });
    } catch (err) {
        console.error('Error selecting character:', err);
        res.status(500).json({ message: 'Server error while selecting character' });
    }
};
