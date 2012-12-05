dir = './'
di_config_file = dir + 'app/DependencyInjection/config.json'
di_write_file = dir + 'app/DependencyInjection/config.coffee'
spacer = '	'
namespace = 'app.di.config'

exec = require('child_process').exec
fs = require('fs')

fs.readFile di_config_file, 'utf8', (err,data) ->
	if err
		return console.log err

	output = "goog.provide '" + namespace + "'\n\n"
	config = "config =\n"

	for service, args of JSON.parse data
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
app.di.config = lowerKeys config"

	fs.writeFile di_write_file, output, (err) ->
		if err
			console.log err
		else
			console.log "The file was saved!"


coffeeCompile = 'coffee --bare --compile ./'

closureBuilder = 'closure-library/closure/bin/build/closurebuilder.py
 --root=closure-library/
 --root=app/ 
 --namespace="app.start"
 --output_mode=compiled
 --compiler_jar=compiler.jar
 > app-compiled.js'


callback = ->
	exec closureBuilder, ->
		console.log 'Compile success.'


exec coffeeCompile, callback
