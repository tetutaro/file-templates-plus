{TextEditorView} = require 'atom-space-pen-views'

crypto = require 'crypto'
fs = require 'fs-plus'
path = require 'path'

{$, View} = require 'space-pen'

module.exports =
	class NewTemplateView extends View
		@content: ->
			@div class: 'overlay from-top', =>
				@h4 'New Template'
				@label 'Template Name'
				@subview 'nameEditor', new TextEditorView(mini: true)
				@label 'Extension'
				@subview 'extEditor', new TextEditorView(mini: true)
				@button outlet: 'createButton', class: 'btn', 'Create'

		initialize: ->
			atom.commands.add @element,
				'core:confirm': => @onConfirm(@nameEditor.getText(), @extEditor.getText())
				'core:cancel': => @destroy()
			@createButton.on 'click', => @onConfirm(@nameEditor.getText(), @extEditor.getText())

		attach: ->
			editor = atom.workspace.getActiveTextEditor()
			if editor
				@panel = atom.workspace.addModalPanel(item: this)
				@nameEditor.focus()
			else
				atom.notifications.addError('File Templates Plus', {detail: 'You have no editor open. Please create your template then run `File Templates Plus: New Template` again to save it.'})

		destroy: ->
			@panel.destroy()
			atom.workspace.getActivePane().activate()

		onConfirm: (name, ext) ->
			ext = ext.replace(/\s+$/, '') # Remove trailing whitespace
			contents = atom.workspace.getActiveTextEditor().getText()
			templateHash = crypto.createHash('sha1').update(name + contents).digest('hex')
			@destroy()
			@nameEditor.setText('')
			@extEditor.setText('')
			fs.readFile path.join(atom.config.get('file-templates-plus.templateStore'), 'index.json'), (err, data) ->
				if err
					if err.code == "ENOENT"
						templates = {}
					else
						throw err
				else
					templates = JSON.parse(data)
				templates[templateHash] = {
					"name": name
					"ext": ext
					"hash": templateHash
					"grammarScope": atom.workspace.getActiveTextEditor().getGrammar().scopeName
				}
				json = JSON.stringify templates
				fs.writeFileSync path.join(atom.config.get('file-templates-plus.templateStore'), 'index.json'), json
				fs.writeFileSync path.join(atom.config.get('file-templates-plus.templateStore'), templateHash + '.template'), contents
				atom.notifications.addSuccess("Template #{name} created")
