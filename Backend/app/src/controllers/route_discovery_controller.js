const expressListEndpoints = require('express-list-endpoints');

exports.get_all_routes = (req, res) => {
    const endpoints = expressListEndpoints(req.app);

    // Optional: Sortiere die Routen alphabetisch
    endpoints.sort((a, b) => a.path.localeCompare(b.path));

    console.log(`Returning routes: ${JSON.stringify(endpoints)}`);
    res.json(endpoints);
};