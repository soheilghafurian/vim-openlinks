" autoload/openlinks.vim - Core logic for openlinks plugin

let s:url_pattern = '\v(https?://|ftp://|file://)\S+|[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.(com|org|net|io|dev|edu|gov|co|uk|me|info|app|xyz)(/\S*)?'

function! s:DetectOpenCommand() abort
  if exists('g:openlinks_command')
    return g:openlinks_command
  endif
  if has('mac') || has('macunix')
    return 'open'
  elseif has('win32') || has('win64')
    return 'start'
  else
    return 'xdg-open'
  endif
endfunction

function! openlinks#ExtractURLsFromLines(lines) abort
  let urls = []
  for line in a:lines
    let start = 0
    while 1
      let [match, s, e] = matchstrpos(line, s:url_pattern, start)
      if s == -1
        break
      endif
      " Strip trailing punctuation that is likely not part of the URL
      let match = substitute(match, '[.)>,;:!?"' . "'" . ']\+$', '', '')
      call add(urls, match)
      let start = e
    endwhile
  endfor
  return urls
endfunction

function! s:ExtractURLs(line1, line2) abort
  return openlinks#ExtractURLsFromLines(getline(a:line1, a:line2))
endfunction

function! s:OpenURL(cmd, url) abort
  let url = a:url
  " Prepend https:// to bare domains
  if url !~# '\v^(https?|ftp|file)://'
    let url = 'https://' . url
  endif
  if exists('*job_start')
    call job_start(['/bin/sh', '-c', a:cmd . ' ' . shellescape(url)])
  elseif exists('*jobstart')
    call jobstart(['/bin/sh', '-c', a:cmd . ' ' . shellescape(url)])
  else
    call system(a:cmd . ' ' . shellescape(url))
  endif
endfunction

function! openlinks#Operator(type) abort
  call openlinks#Open(line("'["), line("']"))
endfunction

function! openlinks#Open(line1, line2) abort
  let urls = s:ExtractURLs(a:line1, a:line2)

  if empty(urls)
    echom 'OpenLinks: No URLs found'
    return
  endif

  let threshold = get(g:, 'openlinks_confirm_threshold', 40)
  if len(urls) >= threshold
    let choice = confirm('Open ' . len(urls) . ' URLs?', "&Yes\n&No", 2)
    if choice != 1
      echom 'OpenLinks: Cancelled'
      return
    endif
  endif

  let cmd = s:DetectOpenCommand()
  for url in urls
    echom 'OpenLinks: ' . url
    call s:OpenURL(cmd, url)
  endfor

  redraw
  echom 'OpenLinks: Opened ' . len(urls) . ' URL(s)'
endfunction
