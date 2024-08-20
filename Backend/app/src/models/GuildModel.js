const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// Guild Schema
const GuildSchema = new Schema({
    name: {
        type: String,
        required: true,
        unique: true,
    },
    members: [{
        type: Schema.Types.ObjectId,
        ref: 'User',
    }],
    stash: {
        type: Schema.Types.ObjectId,
        ref: 'Stash'
    }, // Referenz zum Gilden-Stash
    created_at: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Guild', GuildSchema);

