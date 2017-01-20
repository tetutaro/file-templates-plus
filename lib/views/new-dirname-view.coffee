{SelectListView} = require 'atom-space-pen-views'
NewFilenameView = require './new-filename-view'

module.exports =
	class NewDirnameView extends SelectListView
		template: null

		viewForItem: (item) ->
			"<li>#{item}</li>"

		attach: (template) ->
			@template = template
			@panel = atom.workspace.addModalPanel(item: this)
			@storeFocusedElement()
			@filterEditorView.focus()
			dirs = atom.project.getDirectories()
			if dirs.length == 0
				@setItems([atom.config.get('core.projectHome')])
			else
				@setItems(d.getPath() for d in dirs)

		cancel: ->
			super
			@panel.hide()
			atom.workspace.getActivePane().activate()

		confirmed: (dname) ->
			@cancel
			@newFilenameView = new NewFilenameView(@template, dname)
			@newFilenameView.attach(@template, dname)
