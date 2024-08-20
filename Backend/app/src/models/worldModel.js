// models/worldModel.js
const mongoose = require('mongoose');

// Beispiel für ein Schema für eine statische Karte
const staticMapSchema = new mongoose.Schema({
    name: String,
    tileset: [String],  // Liste von Tile-ID oder Tile-Bildern
    layout: [[String]] // 2D-Array für die Tile-Anordnung
});

// Beispiel für ein Schema für eine dynamische Karte
const dynamicMapSchema = new mongoose.Schema({
    name: String,
    tileset: [String],
    layout: [[String]],
    generated: Boolean
});

// Beispiel für ein Schema für Spielerstatus
const playerSchema = new mongoose.Schema({
    playerId: String,
    position: { x: Number, y: Number },
    inventory: [String],
    status: String
});

const StaticMap = mongoose.model('StaticMap', staticMapSchema);
const DynamicMap = mongoose.model('DynamicMap', dynamicMapSchema);
const Player = mongoose.model('Player', playerSchema);

module.exports = { StaticMap, DynamicMap, Player };
