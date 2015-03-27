GrepView = require './atom-fuzzy-grep-view'

module.exports =
  config:
    # useGitGrepForGitProjects:
    #   type: 'boolean'
    #   default: false
    #   order: 0
    minSymbolsToStartSearch:
      type: 'number'
      default: 3
      order: 1
  activate: ->
    @editorSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle()

  createView: ->
    unless @grepView
      @grepView = new GrepView()
    @grepView
