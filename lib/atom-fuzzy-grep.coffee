GrepView = require './atom-fuzzy-grep-view'

module.exports =
  config:
    detectGitProjectAndUseGitGrep:
      type: 'boolean'
      default: false
      order: 0
    minSymbolsToStartSearch:
      type: 'number'
      default: 3
      order: 1
    grepCommandString:
      type: 'string'
      default: 'ag -i --nocolor --nogroup'
    maxCandidates:
      type: 'number'
      default: 100
  activate: ()->
    @editorSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle()

  createView: ->
    unless @grepView
      @grepView = new GrepView()
    @grepView
