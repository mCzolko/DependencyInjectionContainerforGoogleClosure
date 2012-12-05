goog.provide 'app.di.config'

goog.require 'app.Messenger'
goog.require 'app.ConsoleLogger'
goog.require 'app.Alerter'

config =

	'messenger':
		'class':     app.Messenger
		'arguments': ['@consoleLogger', '@alerter']

	'consoleLogger':
		'class':     app.ConsoleLogger

	'alerter':
		'class':     app.Alerter

lowerKeys = (config) ->
	for key, service of config
		key = new String key
		config[key.toLowerCase()] = service
	return config

app.di.config = lowerKeys config