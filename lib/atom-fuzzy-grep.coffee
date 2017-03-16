GrepView = null

module.exports =

  activate: ->
    @commandSubscription = atom.commands.add 'atom-workspace',
      'fuzzy-grep:toggle': => @createView().toggle(),
      'fuzzy-grep:toggleLastSearch': => @createView().toggleLastSearch(),

  deactivate: ->
    @commandSubscription?.dispose()
    @commandSubscription = null
    @grepView?.destroy()
    @grepView = null

  createView: ->
    GrepView ?= require './atom-fuzzy-grep-view'
    @grepView ?= new GrepView()
