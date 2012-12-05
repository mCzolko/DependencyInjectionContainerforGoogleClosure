###*
	@fileroverview Dependency Injection Container
	@author Michael Czolok <michael@czolko.cz>
###
goog.provide 'DI.Container'
goog.provide 'DI.Container.get'

goog.require 'DI.config'


class DI.Container


	###*
		@construct
	###
	constructor: (@config) ->
		@instances = new Array
		@set 'service_container', @


	###*
		Get service by ID
		@param {string} key
		@return {Object} Service
	###
	get: (key) ->
		key = new String key
		key = key.toLowerCase()

		if @config[key] == undefined
			throw 'Service with key "' + key + '" not found in configuration file'

		if @instances[key] == undefined
			service = @create @config[key]
			@set key, new service

		return @instances[key]



	###*
		Has container service?
		@param {string} key
		@return boolean
	###
	has: (key) ->
		key = new String key
		@instances[key.toLowerCase()] == undefined


	###*
		Initialize and add service to instance collection
		@param {string} key
		@param {Object} service
		@return {Object} Service
	###
	set: (key, service) ->
		key = new String key
		@instances[key.toLowerCase()] = service


	###*
		Create service
		@param {Object} params Mainly contents service dependencies
		@return {Object} Non-initialized service
	###
	create: (params) ->
		# No constructor parameters
		if params['arguments'] == undefined && params['class']
			return params['class']
		else
			if params['arguments']['constructor'] == Array
				services = new Array

				for argument in params['arguments']
					if argument.substr(0, 1) == '@'
						key = argument.substr 1
						services.push @get key
					else
						services.push argument

				instancePlease = @setConstructorArguments params['class'], services

				return instancePlease
		
		throw 'Error in creation class!'


	###*
		Inject services to constructor
		http://stackoverflow.com/questions/3362471/how-can-i-call-a-javascript-constructor-using-call-or-apply/3362623#3362623
		@param {Function} constructor
		@param {Array} services
		@return {Function}
	###
	setConstructorArguments: (constructor, services) ->
		args = Array.prototype.slice.call services, 0
		return () ->
			# Temporary constructor
			Temp = () ->
				return

			# Give the Temp constructor the Constructor's prototype
			Temp.prototype = constructor.prototype

			# Create a new instance
			inst = new Temp

			# Call the original Constructor with the temp
			# instance as its context (i.e. its 'this' value)
			ret = constructor.apply(inst, args)

			# If an object has been returned then return it otherwise
			# return the original instance.
			# (consistent with behaviour of the new operator)
			return ret if Object(ret) == ret
			return inst


DI.Container.get = (config = DI.config) ->
	new DI.Container config

