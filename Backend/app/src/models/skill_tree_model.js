// src/models/skill_tree_model.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const skill_tree_schema = new Schema({
    active: Schema.Types.Mixed,  
    passive: Schema.Types.Mixed
});

module.exports = mongoose.model('SkillTree', skill_tree_schema);
