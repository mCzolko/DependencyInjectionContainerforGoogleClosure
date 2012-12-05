goog.provide 'app.start'

goog.require 'DI.Container.get'


class app.start

	constructor: ->
		@container = DI.Container.get()
		messenger = @container.get 'messenger'
		messenger.showError 'Yes'


new app.start