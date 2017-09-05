const path = require('path');
const express = require('express');
const compression = require('compression');

const app = express();

app.use(express.static(path.join(__dirname, 'public')));

// A route for testing authentication/authorization
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/index.html'));
});

app.use(compression());

module.exports = app;
