'use strict';
const process = require('process');
const request = require('request');

function Utils() {}

Utils.prototype.getHostPortMappings = (callback) => {
  const container = process.env.HOSTNAME;
  request.get(`http://unix/var/run/docker.sock:/containers/${container}/json`, (error, response, body) => {
    if (error) {
      return callback(error);
    }
    try {
      const ports = JSON.parse(body).NetworkSettings.Ports;
      return callback(null, ports);
    } catch (err) {
      return callback(err);
    }
  });
};

module.exports = new Utils();
