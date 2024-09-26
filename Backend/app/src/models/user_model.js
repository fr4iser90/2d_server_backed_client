//user_model
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// User Schema
const user_schema = new Schema({
    username: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    character_slots: {
        type: Number,
        default: 3, // Anzahl der verfügbaren Charakter-Slots
    },
    characters: [{
        type: Schema.Types.ObjectId,
        ref: 'Character'
    }], // Referenz zu den Charakteren des Benutzers
    shared_stash: {
        type: Schema.Types.ObjectId,
        ref: 'Stash'
    }, // Referenz zum Shared Stash
    guilds: [{
        type: Schema.Types.ObjectId,
        ref: 'Guild'
    }], // Referenz zu den Gilden, denen der Benutzer angehört
    selected_character: {
        type: Schema.Types.ObjectId,
        ref: 'Character',
        default: null, // Das Feld ist standardmäßig null, falls kein Charakter ausgewählt ist
    },
    created_at: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('User', user_schema);
