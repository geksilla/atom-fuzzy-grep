# atom-fuzzy-grep package

![demo](https://raw.githubusercontent.com/geksilla/atom-fuzzy-grep/master/demo.gif)

## Install

    apm install atom-fuzzy-grep

Or search via __Settings View -> Install__

## Usage

Hit ```ctrl-alt-g``` or ```, f f``` in vim-mode to toggle panel.

To open dialog with last searched string there is the command ```fuzzy-grep:toggleLastSearch```. You can map it in your ```keymap.cson```:

```
'atom-workspace':
  'ctrl-alt-shift-g': 'fuzzy-grep:toggleLastSearch'
```

To always open dialog with last search string check **Preserve Last Search** in package settings.

You can filter files in opened dialog. Toggle between grep/file mode with ```ctrl-f```.
To change this keybinding add following lines to your *keymaps.cson*:

```
'atom-workspace .atom-fuzzy-grep':
  '<your_keys_here>': 'fuzzy-grep:toggleFileFilter'
```

## Configuration

You can specify any command you want by **Grep Command String** option in package settings,  [ag](https://github.com/ggreer/the_silver_searcher) is used by default.

If you want to setup another one instead of **ag** here few examples:

### [pt](https://github.com/monochromegane/the_platinum_searcher)

    pt -i --nocolor --nogroup --column

### [ack](https://github.com/petdance/ack2)

    ack -i --nocolor --nogroup --column

### grep

    grep -r -n --color=never

### [ripgrep](https://github.com/BurntSushi/ripgrep)

    rg -i -n -H --no-heading --column

### git grep

    git grep -n -E

```git grep``` used by default for git projects if you don't want to use it uncheck **Detect Git Project And Use Git Grep** option in package settings.

Check package settings for more info.

## Caveats

* Search folder detects on project path from active text editor.
* When no editors opened or `Untitled` first project root path used.
* When you have opened several projects and want to search through it you need to open any file from this project and start search dialog.
* When active item not in project home directory used as root dir.
* When no projects opened home directory used as root dir.

## Commands

Name                            | Selector         | Key Map               | Description
--------------------------------|------------------|-----------------------|----------------------------------------------------------------------
__fuzzy-grep:toggle__           | `atom-workspace` | 'ctrl-alt-g' | Open search dialog start typing and select item
__fuzzy-grep:toggleLastSearch__ | `atom-workspace` | none                  | Open dialog with last search string
__fuzzy-grep:toggleFileFilter__ | `atom-workspace .atom-fuzzy-grep atom-text-editor` | 'ctrl-f'     | When search dialog opened toggle file name filtering on found results
__fuzzy-grep:pasteEscaped__ | `body.platform-linux atom-workspace .atom-fuzzy-grep atom-text-editor, body.platform-win32 atom-workspace .atom-fuzzy-grep atom-text-editor` | 'ctrl-v'     | Paste text to dialog and escape it, you can disable this behavior with `atom-fuzzy-grep.escapeOnPaste` config
__fuzzy-grep:pasteEscaped__ | `body.platform-darwin atom-workspace .atom-fuzzy-grep atom-text-editor` | 'cmd-v'     | Paste text to dialog and escape it, you can disable this behavior with `atom-fuzzy-grep.escapeOnPaste` config


## Configs

Name                                              | Default                              | Type      | Description
--------------------------------------------------|--------------------------------------|-----------|-----------------------------------------------------------------------------------
__atom-fuzzy-grep.minSymbolsToStartSearch__       | 3                                    | _number_  | Start search after N symbol
__atom-fuzzy-grep.maxCandidates__                 | 100                                  | _number_  | Maximum count of displayed items
__atom-fuzzy-grep.grepCommandString__             | 'ag -i --nocolor --nogroup --column' | _string_  | Grep command
__atom-fuzzy-grep.detectGitProjectAndUseGitGrep__ | false                                | _boolean_ | Always use `git grep` when opened project is a git repository
__atom-fuzzy-grep.gitGrepCommandString__          | 'git grep -i --no-color -n -E'       | _string_  | `git grep` command used when `detectGitProjectAndUseGitGrep` is true
__atom-fuzzy-grep.preserveLastSearch__            | false                                | _boolean_ | Use last search string as input for search dialog
__atom-fuzzy-grep.escapeSelectedText__            | true                                 | _boolean_ | Escape special characters when dialog opened with selected text
__atom-fuzzy-grep.showFullPath__                  | false                                | _boolean_ | Show full file path instead of file name
__atom-fuzzy-grep.inputThrottle__                 | 50                                   | _integer_ | Input throttle
__atom-fuzzy-grep.escapeOnPaste__                 | true                                 | _boolean_ | Escape pasted text
__atom-fuzzy-grep.fixEnv__                        | true                                 | boolean   | Will fix $PATH variable when running your favourite grep tool, environment package should be installed.


## Contributing

Feel free to open issue or send pull request.
