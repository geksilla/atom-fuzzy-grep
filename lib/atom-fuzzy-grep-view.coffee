{$$, View} = require 'space-pen'
{SelectListView} = require 'atom-space-pen-views'
{BufferedProcess, CompositeDisposable} = require 'atom'
path = require 'path'
Runner = require './runner'
escapeStringRegexp = require 'escape-string-regexp'
fuzzyFilter = null

module.exports =
class GrepView extends SelectListView
  preserveLastSearch: false
  maxItems: 100
  minFilterLength: 3
  showFullPath: false
  runner: null
  lastSearch: ''
  isFileFiltering: false
  escapeOnPaste: true

  initialize: ->
    super
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add(@filterEditorView.element, 'fuzzy-grep:toggleFileFilter', @toggleFileFilter)
    @subscriptions.add atom.commands.add(@filterEditorView.element, 'fuzzy-grep:pasteEscaped', @pasteEscaped)
    @panel = atom.workspace.addModalPanel(item: this, visible: false)
    @addClass 'atom-fuzzy-grep'
    @runner = new Runner
    @setupConfigs()

  setupConfigs: ->
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.minSymbolsToStartSearch', (@minFilterLength) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.maxCandidates', (@maxItems) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.preserveLastSearch', (@preserveLastSearch) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.escapeSelectedText', (@escapeSelectedText) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.showFullPath', (@showFullPath) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.inputThrottle', (@inputThrottle) =>
    @subscriptions.add atom.config.observe 'atom-fuzzy-grep.escapeOnPaste', (@escapeOnPaste) =>

  getFilterKey: ->
    if @isFileFiltering then 'filePath' else ''

  getFilterQuery: ->
    if @isFileFiltering then @filterEditorView.getText() else ''

  viewForItem: ({filePath, line, content, error})->
    that = @
    if error
      @setError error
      return
    $$ ->
      @li class: 'two-lines', =>
        displayedPath = if that.showFullPath then filePath else path.basename filePath
        @div "#{displayedPath}:#{line+1}", class: 'primary-line file icon icon-file-text', 'data-name': displayedPath
        @div content, class: 'secondary-line'

  confirmed: (item)->
    @lastSearch = @filterEditorView.getText()
    @openFile item.fullPath, item.line, item.column
    @cancelled()

  openFile: (filePath, line, column)->
    return unless filePath
    atom.workspace.open(filePath, {initialLine: line, initialColumn: column}).then((editor) ->
      editorElement = atom.views.getView(editor)
      {top} = editorElement.pixelPositionForBufferPosition(editor.getCursorBufferPosition())
      editorElement.setScrollTop(top - editorElement.getHeight() / 2)
    )

  cancelled: ->
    @items = []
    @isFileFiltering = false
    @panel.hide()
    @killRunner()

  grepProject: ->
    return if @minFilterLength and @filterEditorView.getText().length < @minFilterLength
    @killRunner()
    @runner.run(@filterEditorView.getText(), @getProjectPath(), @setItems.bind(@))

  killRunner: ->
    @runner?.destroy()

  getProjectPath: ->
    homeDir = require('os').homedir()
    editor = atom.workspace.getActiveTextEditor()
    return atom.project.getPaths()[0] || homeDir unless editor
    if editor.getPath()
      atom.project.relativizePath(editor.getPath())[0] || path.dirname(editor.getPath())
    else
      atom.project.getPaths()[0] || homeDir

  setSelection: ->
    editor = atom.workspace.getActiveTextEditor()
    if editor?.getSelectedText()
      @filterEditorView.setText editor.getSelectedText()
      @escapeFieldText() if @escapeSelectedText

  escapeFieldText: =>
    escapedString = escapeStringRegexp @filterEditorView.getText()
    @filterEditorView.setText escapedString

  destroy: ->
    @subscriptions?.dispose()
    @subscriptions = null
    @detach()

  toggle: ->
    if @panel?.isVisible()
      @panel?.show()
    else
      @storeFocusedElement()
      @filterEditorView.setText(@lastSearch || '') if @preserveLastSearch
      @panel.show()
      @focusFilterEditor()
      @setSelection()

  toggleLastSearch: ->
    @toggle()
    @filterEditorView.setText(@lastSearch || '')

  toggleFileFilter: =>
    @isFileFiltering = !@isFileFiltering
    if @isFileFiltering
      @tmpSearchString = @filterEditorView.getText()
      @filterEditorView.setText('')
    else
      @filterEditorView.setText(@tmpSearchString)
      @tmpSearchString = ''

  pasteEscaped: (e)=>
    {target} = e
    atom.commands.dispatch target, "core:paste"
    @escapeFieldText() if @escapeOnPaste

  schedulePopulateList: ->
    clearTimeout(@scheduleTimeout)
    filterMethod = if @isFileFiltering then @populateList else @grepProject
    populateCallback = =>
      filterMethod.bind(@)() if @isOnDom()
    @scheduleTimeout = setTimeout(populateCallback,  @inputThrottle)

  setEnv: (env)->
    @runner?.setEnv env
