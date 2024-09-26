const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Stats = require('./stats_model');
const Equipment = require('./equipment_model');
const Inventory = require('./inventory_model');
const CraftingMaterials = require('./crafting_materials_model');
const Stash = require('./stash_model');
const SkillTree = require('./skill_tree_model');
const User = require('./user_model');


// Character Schema with denormalization for frequently accessed data
const character_schema = new Schema({
    name: { type: String, required: true },
    
    scene_name: { type: String, default: 'spawn_room' },
    spawn_point: { type: String, default: 'default_spawn_point' },
    character_class: { type: String, required: true },

    level: { type: Number, default: 1 },
    experience: { type: Number, default: 0 },
    
    last_known_position: {
        x: { type: Number, default: 0 },
        y: { type: Number, default: 0 }
    },
    
    // Denormalized stats
    stats: {
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
    },
    
    // Denormalized basic equipment info
    equipment: {
        weapon: { type: String, default: "Basic Sword" },
        armor: { type: String, default: "Leather Armor" },
        accessory: { type: String, default: "None" }
    },
    
    // Denormalized inventory summary
    inventory_summary: {
        total_gold: { type: Number, default: 0 },
        key_items: [{ type: String }] // important quest items or similar
    },

    // Reference for full inventory if needed
    inventory: [{ type: Schema.Types.ObjectId, ref: 'Inventory' }], 
    
    crafting_materials: { type: Schema.Types.ObjectId, ref: 'CraftingMaterials' },
    stash: { type: Schema.Types.ObjectId, ref: 'Stash' },
    
    // Denormalized skill tree summary
    skills: {
        active_skills: [{ type: String }], // names of active skills
        passive_skills: [{ type: String }] // names of passive skills
    },

    karma_points: { type: Number, default: 0 },
    beyond_points: { type: Number, default: 0 },
    
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },

    created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Character', character_schema);
