{SelectListView} = require 'atom-space-pen-views'
NewFilenameView = require './new-filename-view'
fs = require 'fs'
fsplus = require 'fs-plus'

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
				dirlist = []
				ignorelist = []
				for d in dirs
					projectDir = d.getPath()
					@add_dir(projectDir, dirlist, ignorelist)
				@setItems(dirlist)

		add_dir: (dir, dirlist, ignorelist) ->
			dirlist.push dir
			dir_gitignore = dir + '/.gitignore'
			if fsplus.existsSync(dir_gitignore)
				ignores = fs.readFileSync(dir_gitignore, 'utf-8').split("\n")
				for i in ignores
					if i.substring(0, 1) != "#" and i.trim().length > 0
						ignorelist.push i.trim()
			dirpaths = fsplus.listSync(dir)
			for dp in dirpaths
				dirname = dp.split("/")
				dirname = dirname[dirname.length - 1]
				if dirname.substring(0, 1) != "." and dirname not in ignorelist and fsplus.isDirectorySync(dp)
					copyignore = []
					for i in ignorelist
						copyignore.push i
					@add_dir(dp, dirlist, ignorelist)

		cancel: ->
			super
			@panel.hide()
			atom.workspace.getActivePane().activate()

		confirmed: (dname) ->
			@cancel
			@newFilenameView = new NewFilenameView(@template, dname)
			@newFilenameView.attach(@template, dname)
