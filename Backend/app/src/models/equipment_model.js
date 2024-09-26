// src/models/equipment_model.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const equipment_schema = new Schema({
    head: { type: String, default: null },
    chest: { type: String, default: null },
    legs: { type: String, default: null },
    weapon: { type: String, default: null },
    shield: { type: String, default: null },
    trinket_1: { type: String, default: null },
    trinket_2: { type: String, default: null },
    ring_1: { type: String, default: null },
    ring_2: { type: String, default: null },
    boots: { type: String, default: null },
    gloves: { type: String, default: null },
    belt: { type: String, default: null },
    pet: { type: String, default: null }
});

module.exports = mongoose.model('Equipment', equipment_schema);
