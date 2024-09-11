const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const character_schema = new Schema({
    name: { type: String, required: true },
    
    // Scenes and spawn points needs to be mapped in server
    scene_name: { type: String, default: 'spawn_room' },
    spawn_point: { type: String, default: 'default_spawn_point' },
    character_class: { type: String, required: true },  // e.g., "knight", "mage"

    level: { type: Number, default: 1 },
    experience: { type: Number, default: 0 },
    
    last_known_position: {
        x: { type: Number, default: 0 },
        y: { type: Number, default: 0 }
       //z: { type: Number, default: 0 }  // Optional, used for 3D
    },   
    
    stats: {
        strength: { type: Number, default: 1 },
        dexterity: { type: Number, default: 1 },
        intelligence: { type: Number, default: 1 },
        vitality: { type: Number, default: 1 },
        agility: { type: Number, default: 1 },  // New stat
        luck: { type: Number, default: 1 },  // New stat for critical hits or rare finds
        charisma: { type: Number, default: 1 },  // New stat for social interactions, trading
        wisdom: { type: Number, default: 1 },  // New stat for magic defense, resource management
        stamina: { type: Number, default: 100 },  // Health or energy pool
        mana: { type: Number, default: 100 }  // Magic resource pool
    },

    karma_points: { type: Number, default: 0 },
    beyond_points: { type: Number, default: 0 },
    
    // Skill trees for active and passive abilities
    active_skill_tree: Schema.Types.Mixed,  
    passive_skill_tree: Schema.Types.Mixed, 

    // Expanded equipment slots, including accessories like trinkets and rings
    equipment: {
        head: { type: String, default: null },
        chest: { type: String, default: null },
        legs: { type: String, default: null },
        weapon: { type: String, default: null },
        shield: { type: String, default: null },
        trinket_1: { type: String, default: null },  // New slot for a trinket (e.g., amulet)
        trinket_2: { type: String, default: null },  // New slot for another trinket
        ring_1: { type: String, default: null },  // New slot for a ring
        ring_2: { type: String, default: null },  // New slot for another ring
        boots: { type: String, default: null },  // Boots slot for armor
        gloves: { type: String, default: null },  // Gloves slot for armor
        belt: { type: String, default: null },  // Belt slot for additional stats or abilities
        pet: { type: String, default: null }  // New slot for a pet or companion
    },

    // Backpack or inventory, where players can store multiple items
    inventory: [{
        item_id: { type: String, default: null },
        quantity: { type: Number, default: 1 }
    }],

    // Crafting materials that characters can hold, like ores, herbs, or scrolls
    crafting_materials: {
        ores: { type: Number, default: 0 },
        herbs: { type: Number, default: 0 },
        scrolls: { type: Number, default: 0 }
    },
    
    stash: { type: Schema.Types.ObjectId, ref: 'Stash' },
    // Linked user (owner of the character)
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },

    // Creation timestamp
    created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Character', character_schema);
