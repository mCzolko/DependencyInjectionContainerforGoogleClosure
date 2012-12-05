goog.provide 'app.start'

goog.require 'dependencyInjection.Container.get'


class app.start

	constructor: ->
		@container = dependencyInjection.Container.get()
		messenger = @container.get 'messenger'
		messenger.showError 'Yes'


new app.start