// src/models/world_model.js
const mongoose = require('mongoose');

// Beispiel für ein Schema für eine statische Karte
const static_map_schema = new mongoose.Schema({
    name: String,
    tileset: [String],  // Liste von Tile-ID oder Tile-Bildern
    layout: [[String]] // 2D-Array für die Tile-Anordnung
});

// Beispiel für ein Schema für eine dynamische Karte
const dynamic_map_schema = new mongoose.Schema({
    name: String,
    tileset: [String],
    layout: [[String]],
    generated: Boolean
});

// Beispiel für ein Schema für Spielerstatus
const player_schema = new mongoose.Schema({
    player_id: String,
    position: { x: Number, y: Number },
    inventory: [String],
    status: String
});

const StaticMap = mongoose.model('StaticMap', static_map_schema);
const DynamicMap = mongoose.model('DynamicMap', dynamic_map_schema);
const Player = mongoose.model('Player', player_schema);

module.exports = { StaticMap, DynamicMap, Player };
