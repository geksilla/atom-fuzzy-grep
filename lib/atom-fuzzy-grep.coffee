GrepView = null

module.exports =
  config:
    minSymbolsToStartSearch:
      type: 'number'
      default: 3
      order: 0
    maxCandidates:
      type: 'number'
      default: 100
      order: 1
    grepCommandString:
      type: 'string'
      default: 'ag -i --nocolor --nogroup --column'
      order: 2
    detectGitProjectAndUseGitGrep:
      type: 'boolean'
      default: true
      order: 3
    gitGrepCommandString:
      type: 'string'
      default: 'git grep -i --no-color -n -e'
      order: 4
    preserveLastSearch:
      type: 'boolean'
      default: false
      order: 5
    escapeSelectedText:
      type: 'boolean'
      default: false
      order: 6

  activate: ->
    @editorSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle(),
      'fuzzy-grep:toggleLastSearch': => @createView().toggleLastSearch()

  deactivate: ->
    @grepView?.destroy()
    @grepView = null

  createView: ->
    GrepView ?= require './atom-fuzzy-grep-view'
    unless @grepView
      @grepView = new GrepView()
    @grepView
