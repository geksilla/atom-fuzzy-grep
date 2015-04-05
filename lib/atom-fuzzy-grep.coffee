GrepView = require './atom-fuzzy-grep-view'

module.exports =
  config:
    detectGitProjectAndUseGitGrep:
      type: 'boolean'
      default: true
      order: 0
    minSymbolsToStartSearch:
      type: 'number'
      default: 3
      order: 1
    grepCommandString:
      type: 'string'
      default: 'ag -i --nocolor --nogroup --column'
    maxCandidates:
      type: 'number'
      default: 100

  activate: ->
    @editorSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle()

  deactivate: ->
    @grepView?.destroy()
    @grepView = null

  createView: ->
    unless @grepView
      @grepView = new GrepView()
    @grepView
