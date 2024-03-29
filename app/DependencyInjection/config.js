// Generated by CoffeeScript 1.3.3
var config, lowerKeys;

goog.provide('DI.config');

goog.require('app.Messenger');

goog.require('app.ConsoleLogger');

goog.require('app.Alerter');

config = {
  'messenger': {
    'class': app.Messenger,
    'arguments': ['@consoleLogger', '@alerter']
  },
  'consoleLogger': {
    'class': app.ConsoleLogger
  },
  'alerter': {
    'class': app.Alerter
  }
};

lowerKeys = function(config) {
  var key, service;
  for (key in config) {
    service = config[key];
    key = new String(key);
    config[key.toLowerCase()] = service;
  }
  return config;
};

DI.config = lowerKeys(config);
