###*
	Configuration
###
dir = './'
di_config_file = dir + 'app/DependencyInjection/config.json'
di_write_file = dir + 'app/DependencyInjection/config.coffee'
spacer = '	'
namespace = 'dependencyInjection.config'


###*
	Require modules
###
exec = require('child_process').exec
fs = require('fs')


###*
	Task 1
	Read JSON config a creates CoffeeScript config file
###
createConfig = ->
	fs.readFile di_config_file, 'utf8', (err,data) ->
		if err
			return console.log err

		output = getCoffeeScriptFile di_write_file, namespace, JSON.parse data

		fs.writeFile di_write_file, output, (err) ->
			if err
				console.log err
			else
				console.log "CoffeeScript config file saved to path " + di_write_file

###*
	Task 2
	CoffeeScripts compilation.
###
coffeeCompile = 'coffee --bare --compile ./'


###*
	Task 3
	Closure build.
###
closureBuilder = 'closure-library/closure/bin/build/closurebuilder.py
 --root=closure-library/
 --root=app/ 
 --namespace="app.start"
 --output_mode=compiled
 --compiler_jar=compiler.jar
 > app-compiled.js'



###*
	Generate CoffeeScript config file.
	Helper
###
getCoffeeScriptFile = (filePath, namespace, services) ->
	output = "goog.provide '" + namespace + "'\n\n"
	config = "config =\n"


	for service, args of services
		config += "\n" + spacer + "'" + service + "':\n"
		config += spacer + spacer + "'class':     " + args.class + "\n"
		output += "goog.require '" + args.class + "'\n"

		if args.arguments != undefined
			config += spacer + spacer + "'arguments': ['"
			config += args.arguments.join "', '"
			config += "']\n"

	output += "\n" + config + "\n
lowerKeys = (config) ->\n
	for key, service of config\n
		key = new String key\n
		config[key.toLowerCase()] = service\n
	return config\n\n
" + namespace + " = lowerKeys config"

	return output


###*
	Run tasks
###
createConfig()

exec coffeeCompile, ->
	console.log 'CoffeeScript compile done.'

exec closureBuilder, ->
	console.log 'Google Closure compile done.'