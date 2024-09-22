const User = require('../models/user_model');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const passport = require('passport');
const character_controller = require('./character_controller');

// Registrierung eines neuen Benutzers
exports.register = async (req, res, next) => {
    const { username, password } = req.body;
    console.log(`User ${username} attempting to register`);

    try {
        let user = await User.findOne({ username });

        if (user) {
            return res.status(400).json({ message: 'Username already exists' });
        }

        // Benutzer erstellen und Passwort hashen
        user = new User({ username, password });
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(password, salt);

        await user.save();
        console.log(`User ${username} registered successfully, creating Characters`);

        // Standardcharaktere für den Benutzer erstellen
        await character_controller.create_default_characters_for_user(user._id);
        console.log(`Characters for ${username} created successfully`);

        return res.status(201).json({ message: 'User and default characters registered successfully' });

    } catch (err) {
        console.error('Server error during registration:', err);
        return res.status(500).send('Server error');
    }
};


// Login eines Benutzers
// Login eines Benutzers
exports.login = async (req, res, next) => {
    const { username, password } = req.body;
    console.log(`User ${username} attempting to login`);

    try {
        let user = await User.findOne({ username });

        if (!user) {
            // Wenn der Benutzer nicht existiert, registriere ihn
            console.log(`User ${username} does not exist. Registering new user.`);

            user = new User({ username, password });

            // Passwort hashen
            const salt = await bcrypt.genSalt(10);
            user.password = await bcrypt.hash(password, salt);

            // Benutzer speichern und sicherstellen, dass das Speichern abgeschlossen ist
            await user.save();
            console.log(`User ${username} registered successfully, creating Characters`);

            // Standardcharaktere für den Benutzer erstellen
            await character_controller.create_default_characters_for_user(user._id);
            console.log(`Characters for ${username} created successfully`);
            
            // Nach der Registrierung müssen wir den Benutzer erneut aus der DB abrufen,
            // um sicherzustellen, dass alle Daten korrekt sind (falls nötig)
            user = await User.findOne({ username });
        }

        // Authentifizieren, nachdem sichergestellt wurde, dass der Benutzer existiert
        passport.authenticate('local', { session: false }, (err, user, info) => {
            if (err || !user) {
                console.log(`Login failed for user ${username}`);
                return res.status(400).json({ message: info ? info.message : 'Login failed', user });
            }

            req.login(user, { session: false }, (err) => {
                if (err) {
                    console.error('Login error:', err);
                    return res.status(500).send(err);
                }

                console.log(`User ${user.username} logged in successfully`);
                const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
                // Gebe auch die user_id in der Antwort zurück
                return res.json({ token, user_id: user._id });
            });
        })(req, res, next);

    } catch (err) {
        console.error('Server error during login:', err);
        res.status(500).send('Server error');
    }
};


// Logout eines Benutzers
exports.logout = (req, res, next) => {
    req.logout((err) => {
        if (err) {
            console.error('Logout error:', err);
            return res.status(500).json({ message: 'Logout failed' });
        }
        console.log('User logged out successfully');
        res.json({ message: 'User logged out successfully' });
    });
};
