{BufferedProcess} = require 'atom'

module.exports =
  class Runner
    commandString: null
    process: null

    constructor: (@search, @folder)->
      atom.config.observe 'atom-fuzzy-grep.grepCommandString', =>
        @commandString = atom.config.get 'atom-fuzzy-grep.grepCommandString'

    run: (callback)->
      [command, args...] = @commandString.split(/\s/)
      args = args.concat @search, @folder

      stdout = (output)=>
        @parseOutput(output, callback)
      stderr = (error)->
        callback(error: error)
      @process = new BufferedProcess({command, args, stdout, stderr})
      @process

    parseOutput: (output, callback)->
      items = []
      for item in output.split(/\n/)
        break unless item.length
        [path, line, content...] = item.split(':')
        content = content.join ':'
        items.push
          filePath: path
          line: line-1
          column: @getColumn content
          content: content.replace(/^s+/g, '')
      callback items

    getColumn: (content)->
      # escaped characters in regexp can cause error
      # skip it for a while
      try
        match = content.match(new RegExp(@search, 'gi'))?[0]
      catch error
        match = false
      if match then content.indexOf(match) else 0

    destroy: ->
      @process.kill()
