const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Stash Schema
const stash_schema = new Schema({
    items: [{
        type: String,
        default: [] // Liste von Items im Stash
    }],
    owner_type: {
        type: String,
        enum: ['Character', 'User', 'Guild'],
        required: true,
    },
    owner: {
        type: Schema.Types.ObjectId,
        refPath: 'owner_type' // Dynamische Referenz je nach owner_type
    },
    created_at: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Stash', stash_schema);
