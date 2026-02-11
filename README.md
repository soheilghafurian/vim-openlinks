# vim-openlinks

A Vim plugin that extracts and opens all URLs found in a given line range.

## Installation

### Vundle

```vim
Plugin 'soheilghafurian/vim-openlinks'
```

### vim-plug

```vim
Plug 'soheilghafurian/vim-openlinks'
```

### Manual

Clone this repository into your Vim packages directory:

```bash
mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/yourusername/vim-openlinks.git
```

## Usage

The plugin provides a single command, `:OpenLinks`, which accepts any standard ex range:

```vim
:OpenLinks              " current line
:5,10OpenLinks          " lines 5-10
:'<,'>OpenLinks         " visual selection
:%OpenLinks             " entire buffer
```

### URL Detection

The plugin detects:

- **Scheme URLs** — `https://`, `http://`, `ftp://`, `file://` followed by non-whitespace characters
- **Bare domains** — words containing a dot followed by a known TLD (`com`, `org`, `net`, `io`, `dev`, `edu`, `gov`, `co`, `uk`, `me`, `info`, `app`, `xyz`)

Bare domains are automatically prefixed with `https://` when opened. Trailing punctuation (periods, commas, parentheses, quotes, etc.) is stripped from matched URLs.

## Configuration

### `g:openlinks_command`

Shell command used to open URLs. If not set, the plugin auto-detects based on OS:

| OS      | Default command |
|---------|-----------------|
| macOS   | `open`          |
| Linux   | `xdg-open`      |
| Windows | `start`         |

```vim
let g:openlinks_command = 'firefox'
```

### `g:openlinks_confirm_threshold`

Number of URLs that triggers a confirmation prompt before opening. Default: `40`.

```vim
let g:openlinks_confirm_threshold = 10
```

## Running Tests

Tests use [vader.vim](https://github.com/junegunn/vader.vim). The test runner clones it automatically on first run:

```bash
./test/run_tests.sh
```

## License

MIT
