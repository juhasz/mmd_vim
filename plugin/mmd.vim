let g:mmdTmpDir = '/tmp'
let g:mmdOpenCommand = 'open'

function! MmdCompile(...)
  if exists('a:1') && a:1 != g:mmdTmpDir
    let l:dir = a:1
    let l:pref = ''
  else
    let l:dir = g:mmdTmpDir
    let l:pref = 'vimmmd_'
  endif
  if exists('a:2')
    let l:format = a:2
  else
    let l:format = 'html'
  endif
  write %
  let l:name = escape(expand('%:t:r'), ' ')
  let l:oPath = l:dir . '/' . l:pref . l:name . '.' . l:format
  let l:cmd = 'silent !multimarkdown -t ' . l:format . ' -o ' . l:oPath . ' ' . escape(expand('%:p'), ' ')
  exec l:cmd
  return l:oPath
endfunction

function! MmdOpen(...)
  if exists('a:1')
    let l:format = a:1
  else
    let l:format = 'html'
  endif
  let l:path = MmdCompile(g:mmdTmpDir, l:format)
  if exists('a:2') && a:2 == 'source'
    exec 'silent vne' . l:path
  else
    exec 'silent !' . g:mmdOpenCommand . ' ' . l:path
  endif
endfunction

" delete tmp directory on exit
let s:rmString = 'silent !rm ' . g:mmdTmpDir . '/vimmmd_*'
autocmd VimLeave * exec s:rmString

autocmd BufNewFile,BufRead *.{md,mkd,mkdn,mark*} nnoremap <Leader>mmo :call MmdOpen()<CR>
