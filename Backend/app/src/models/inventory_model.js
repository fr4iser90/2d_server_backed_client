// src/models/inventory_model.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const inventory_schema = new Schema({
    item_id: { type: String, default: null },
    quantity: { type: Number, default: 1 }
});

module.exports = mongoose.model('Inventory', inventory_schema);
