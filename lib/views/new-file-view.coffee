TemplateListView = require './template-list-view'
NewDirnameView = require './new-dirname-view'

module.exports =
	class NewFileView extends TemplateListView
		newDirnameView: null
		
		confirmed: (item) ->
			@cancel()
			@newDirnameView = new NewDirnameView
			@newDirnameView.attach(item)
