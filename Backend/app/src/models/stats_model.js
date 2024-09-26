// src/models/stats_model.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const stats_schema = new Schema({
    strength: { type: Number, default: 1 },
    dexterity: { type: Number, default: 1 },
    intelligence: { type: Number, default: 1 },
    vitality: { type: Number, default: 1 },
    agility: { type: Number, default: 1 },
    luck: { type: Number, default: 1 },
    charisma: { type: Number, default: 1 },
    wisdom: { type: Number, default: 1 },
    stamina: { type: Number, default: 100 },
    mana: { type: Number, default: 100 }
});

module.exports = mongoose.model('Stats', stats_schema);
