goog.provide 'app.start'

goog.require 'app.di.Container.build'


class app.start

	constructor: ->
		@container = app.di.Container.build()
		messenger = @container.get 'messenger'
		messenger.showError 'Yes'


new app.start