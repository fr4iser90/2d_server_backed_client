const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Referenzierte Sub-Dokumente
const Stats = require('./stats_model');
const Equipment = require('./equipment_model');
const Inventory = require('./inventory_model');
const CraftingMaterials = require('./crafting_materials_model');
const Stash = require('./stash_model');
const SkillTree = require('./skill_tree_model');
const User = require('./user_model');

// Character Schema
const character_schema = new Schema({
    name: { 
        type: String, 
        required: true, 
        trim: true, 
        minlength: 2, 
        maxlength: 50 
    },
    character_class: { 
        type: String, 
        required: true, 
        enum: ['Mage', 'Knight', 'Archer'] // Beispiel für Klassen
    },
    level: { 
        type: Number, 
        default: 1, 
        min: 1, 
        max: 100 // Beispiel für maximale Levelgrenze
    },
    experience: { 
        type: Number, 
        default: 0 
    },
    current_area: { 
        type: String, 
        default: 'spawn_room' 
    },
    checkpoint_id: { 
        type: String, 
    },
    attributes: {  // Plural für bessere Namenskonvention
        strength: { type: Number, default: 1, min: 0, max: 999 },
        dexterity: { type: Number, default: 1, min: 0, max: 999 },
        intelligence: { type: Number, default: 1, min: 0, max: 999 },
        vitality: { type: Number, default: 1, min: 0, max: 999 },
        agility: { type: Number, default: 1, min: 0, max: 999 },
        luck: { type: Number, default: 1, min: 0, max: 999 },
        charisma: { type: Number, default: 1, min: 0, max: 999 },
        wisdom: { type: Number, default: 1, min: 0, max: 999 },
        stamina: { type: Number, default: 100, min: 0, max: 100000 },
        mana: { type: Number, default: 100, min: 0, max: 100000 }
    },
    equipment: { 
        weapon: { type: String, default: "Basic Sword" },
        armor: { type: String, default: "Leather Armor" },
        accessory: { type: String, default: "None" }
    },
    inventory_summary: {
        total_gold: { type: Number, default: 0 },
        key_items: [{ type: String }]
    },
    inventory: [{ type: Schema.Types.ObjectId, ref: 'Inventory' }],
    crafting_materials: { type: Schema.Types.ObjectId, ref: 'CraftingMaterials' },
    stash: { type: Schema.Types.ObjectId, ref: 'Stash' },
    skills: {
        active_skills: [{ type: String }],
        passive_skills: [{ type: String }]
    },
    karma_points: { type: Number, default: 0 },
    beyond_points: { type: Number, default: 0 },
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
}, { 
    timestamps: true,  // Fügt automatisch createdAt und updatedAt Felder hinzu
    toJSON: {
        virtuals: true,  
        versionKey: false, // Entfernt das __v Feld
        transform: function (doc, ret) {
            delete ret.createdAt;  // Entfernt das createdAt Feld
            delete ret.updatedAt;  // Entfernt das updatedAt Feld
            return ret;
        }
    },
    toObject: {
        virtuals: true,     
        versionKey: false,  // Entfernt das __v Feld
        transform: function (doc, ret) {
            delete ret.createdAt;  // Entfernt das createdAt Feld
            delete ret.updatedAt;  // Entfernt das updatedAt Feld
            return ret;
        }
    }
});

// Indizes für häufig verwendete Felder
character_schema.index({ user: 1 });
character_schema.index({ level: -1 });

// Middleware für Validierung
character_schema.pre('save', function(next) {
    if (this.level < 1) {
        return next(new Error('Level cannot be less than 1.'));
    }
    next();
});

module.exports = mongoose.model('Character', character_schema);