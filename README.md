# atom-fuzzy-grep package

![demo](https://raw.githubusercontent.com/geksilla/atom-fuzzy-grep/master/demo.gif)

##Install

    apm install atom-fuzzy-grep

##Usage

Hit ```ctrl-alt-g``` or ```, f f``` in vim-mode to toggle panel.

To open dialog with last searched string there is the command ```fuzzy-grep:toggleLastSearch```. You can map it in your ```keymap.cson```:

```
'atom-workspace':
  'ctrl-alt-shift-g': 'fuzzy-grep:toggleLastSearch'
```

To always open dialog with last search string check **Preserve Last Search** in package settings.

##Configuration

You can specify any command you want by **Grep Command String** option in package settings,  [ag](https://github.com/ggreer/the_silver_searcher) is used by default.

If you wan to setup another one instead of **ag** here few examples:

### [ack](https://github.com/petdance/ack2)

    ack -i --nocolor --nogroup --column

### grep

    grep -r -n --color=never

### git grep

    git grep -n -e

```git grep``` used by default for git projects if you don't want to use it uncheck **Detect Git Project And Use Git Grep** option in package settings.

Check package settings for more info.

##Contributing

Feel free to open issue or send pull request.
