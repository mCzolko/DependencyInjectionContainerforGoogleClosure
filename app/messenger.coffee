goog.provide 'app.Messenger'


class app.Messenger

	constructor: (@consoleLogger, @alerter) ->


	show: (type, message) ->
		@consoleLogger.log type + ': ' + message
		@alerter.alert type + ': ' + message


	showError: (message) ->
		@show 'error', message