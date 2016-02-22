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

  consumeEnvironment: (env)->
    @grepView?.setEnv(env) if @shouldFixEnv()

  shouldFixEnv: ->
    atom.config.get('atom-fuzzy-grep.fixEnv') and process.platform is 'darwin'
