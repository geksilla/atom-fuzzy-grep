{$$, View} = require 'space-pen'
{SelectListView} = require 'atom-space-pen-views'
{CompositeDisposable, BufferedProcess, Point} = require 'atom'
path = require 'path'
Runner = require './runner'

module.exports =
class GrepView extends SelectListView
  process: null
  minFilterLength: null

  initialize: ->
    super
    @filterEditorView.getModel().getBuffer().onDidChange =>
      @grepProject()

    @panel = atom.workspace.addModalPanel(item: this, visible: false)
    @addClass 'atom-fuzzy-grep-list'
    atom.config.observe 'atom-fuzzy-grep.minSymbolsToStartSearch', =>
      @minFilterLength = atom.config.get 'atom-fuzzy-grep.minSymbolsToStartSearch'
    atom.config.observe 'atom-fuzzy-grep.maxCandidates', =>
      @maxItems = atom.config.get 'atom-fuzzy-grep.maxCandidates'

  getFilterKey: ->

  getFilterQuery: -> ''

  viewForItem: ({filePath, line, content, error})->
    $$ ->
      @li class: 'two-lines', =>
        fileBasePath = path.basename filePath
        @div "#{fileBasePath}:#{line+1}", class: 'primary-line file icon icon-file-text', 'data-name': fileBasePath
        @div content, class: 'secondary-line'

  confirmed: (item)->
    @openFile item.filePath, item.line, item.column
    @cancelled()

  openFile: (filePath, line, column)->
    if filePath
      atom.workspace.open(filePath).done =>
        @moveCursor line, column

  moveCursor: (line=-1, column=0)->
    return unless line >=0

    if textEditor = atom.workspace.getActiveTextEditor()
      position = new Point(line)
      textEditor.scrollToBufferPosition(position, center: true)
      textEditor.setCursorBufferPosition(position)
      if column > 0
        textEditor.moveRight column
      else
        textEditor.moveToFirstCharacterOfLine()

  cancelled: ->
    @items = []
    @panel.hide()
    @killRunner()

  grepProject: ->
    return if @minFilterLength and @filterEditorView.getText().length < @minFilterLength
    @killRunner()
    @process = new Runner(@filterEditorView.getText(), @getProjectPath())
    @process.run(@setItems.bind(@))

  getProjectPath: ->
    # TODO not sure if this a proper way
    atom.project.getPaths().filter((item)->
      atom.workspace.getActiveTextEditor().buffer.file.path.startsWith item
    )[0]

  killRunner: ->
    return unless @process
    @process.destroy()
    @process = null

  toggle: ()->
    if @panel?.isVisible()
      @panel?.show()
    else
      @storeFocusedElement()
      @panel.show()
      @focusFilterEditor()
