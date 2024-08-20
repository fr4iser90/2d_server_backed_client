const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Character Schema
const CharacterSchema = new Schema({
    name: {
        type: String,
        required: true,
    },
    level: {
        type: Number,
        default: 1,
    },
    experience: {
        type: Number,
        default: 0,
    },
    class: {
        type: String,
        required: true,
    },
    stats: {
        strength: { type: Number, default: 1 },
        dexterity: { type: Number, default: 1 },
        intelligence: { type: Number, default: 1 },
        vitality: { type: Number, default: 1 },
    },
    paragon_points: {
        type: Number,
        default: 0,
    },
    active_skill_tree: {
        type: Schema.Types.Mixed,
    },
    passive_skill_tree: {
        type: Schema.Types.Mixed,
    },
    equipment: {
        head: { type: String, default: null },
        chest: { type: String, default: null },
        legs: { type: String, default: null },
        weapon: { type: String, default: null },
        shield: { type: String, default: null },
    },
    inventory: [{
        type: String,
        default: [],
    }],
    stash: {
        type: Schema.Types.ObjectId,
        ref: 'Stash',
    },
    last_scene: {
        path: {
            type: String,
            default: 'res://src/Data/Levels/Spawn/Test/SpawnRoom.tscn', // Standard-Spawn-Punkt
        },
        spawn_point: {
            type: String, // Name des festgelegten Spawnpunkts
            default: 'DefaultSpawnPoint', // Standardwert, falls nichts gesetzt ist
        }
    },
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    created_at: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Character', CharacterSchema);
