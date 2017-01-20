{TextEditorView} = require 'atom-space-pen-views'
{View} = require 'space-pen'
fs = require 'fs-plus'
path = require 'path'
mkdirp = require 'mkdirp'

Macros = require '../macros'

module.exports =
	class NewFilenameView extends View
		template: null
		dname: null

		@content: (template, dname) ->
			@div class: 'overlay from-top', =>
				@h4 'New File: Input filename'
				@label dname + '/[filename]' + template.ext
				@subview 'fnameEditor', new TextEditorView(mini: true)
				@button outlet: 'createButton', class: 'btn', 'Create'

		initialize: ->
			atom.commands.add @element,
				'core:confirm': => @onConfirm(@fnameEditor.getText())
				'core:cancel': => @destroy()
			@createButton.on 'click', => @onConfirm(@fnameEditor.getText())

		attach: (template, dname)->
			@panel = atom.workspace.addModalPanel(item: this)
			@fnameEditor.focus()
			@fnameEditor.focus() # I should invoke focus() twice to focus fnameEditor
			@template = template
			@dname = dname

		destroy: ->
			@panel.destroy()
			atom.workspace.getActivePane().activate()

		onConfirm: (fname) ->
			@destroy()
			fname = fname.replace(/\s+$/, '') # Remove trailing whitespace
			filename = path.join(@dname, fname + @template.ext)
			dirname = path.dirname(filename)
			if fs.isDirectorySync(dirname)
				if fs.existsSync(filename)
					atom.notifications.addError("#{filename} is aleardy exists.")
					return
			else
				mkdirp.sync(dirname)
			hash = @template.hash
			grammarScope = @template.grammarScope
			atom.workspace.open().then ->
				contents = Macros.process fs.readFileSync path.join(atom.config.get('file-templates-plus.templateStore'), hash + '.template'), "utf8"
				grammar = atom.grammars.grammarForScopeName(grammarScope)
				atom.workspace.getActiveTextEditor().setText(contents)
				if grammar
					atom.workspace.getActiveTextEditor().setGrammar(grammar)
				atom.workspace.getActiveTextEditor().saveAs(filename)
				atom.notifications.addSuccess("#{filename} is created.")
