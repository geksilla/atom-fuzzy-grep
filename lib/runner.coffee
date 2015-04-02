{BufferedProcess} = require 'atom'

module.exports =
  class Runner
    commandString: null
    process: null
    useGitGrep: false

    constructor: (@search, @rootPath)->
      atom.config.observe 'atom-fuzzy-grep.grepCommandString', =>
        @commandString = atom.config.get 'atom-fuzzy-grep.grepCommandString'
      atom.config.observe 'atom-fuzzy-grep.detectGitProjectAndUseGitGrep', =>
        @useGitGrep = atom.config.get 'atom-fuzzy-grep.detectGitProjectAndUseGitGrep'

    run: (callback)->
      @commandString = 'git grep -n -e' if @useGitGrep and @isGitRepo()
      [command, args...] = "#{@commandString} #{@search}".split(/\s/)
      options = cwd: @rootPath

      stdout = (output)=>
        @parseOutput(output, callback)
      stderr = (error)->
        callback(error: error)
      @process = new BufferedProcess({command, args, stdout, stderr, options})
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
      @process?.kill()

    isGitRepo: ->
      atom.project.repositories.some (item)=>
        @rootPath.startsWith item.repo?.workingDirectory
