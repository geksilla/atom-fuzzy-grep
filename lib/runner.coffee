AgRunner = require './ag-runner'
{CompositeDisposable} = require 'atom'

module.exports =
  class Runner
    runner: null
    process: null

    constructor: (@search, @folder)->
      @runner = new AgRunner(@search, @folder)

    run: (callback)->
      @process = @runner.run(callback)

    destroy: ->
      @runner.destroy()
