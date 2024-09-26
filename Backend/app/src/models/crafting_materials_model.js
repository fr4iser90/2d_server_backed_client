// src/models/crafting_materials_model.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const crafting_materials_schema = new Schema({
    ores: { type: Number, default: 0 },
    herbs: { type: Number, default: 0 },
    scrolls: { type: Number, default: 0 }
});

module.exports = mongoose.model('CraftingMaterials', crafting_materials_schema);
