GrepView = require './atom-fuzzy-grep-view'

module.exports =
  config:
    useGitGrepForGitProjects: false
  activate: ->
    @editorSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle()

  createView: ->
    unless @grepView
      @grepView = new GrepView()
    @grepView
