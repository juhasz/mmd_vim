if !exists('g:mmdTmpDir')
  let g:mmdTmpDir = '/tmp'
endif

if !exists('g:mmdOpenCommand')
  let g:mmdOpenCommand = 'open'
endif

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

if has("autocmd")
  autocmd VimLeave * exec s:rmString

  augroup text
    autocmd BufRead,BufNewFile *.{mark*,md,mkd,mkdn} set filetype=markdown
    autocmd FileType markdown nnoremap <Leader>mmo :call MmdOpen()<CR>
  augroup END
endif


function! MmdIncreaseHeader()
  silent +1g/^==\+$/norm ddk
  silent +1g/^--\+$/norm ddkyypVr=k
  silent .g/^### /norm 0df yypVr-k
  silent .g/^##\? /norm 0x2P
endfunction

function! MmdDecreaseHeader()
  silent .g/^#/norm x
  silent .g/^ /norm x
  silent +1g/^--\+$/norm ddkI### 
  silent +1g/^==\+$/norm ddkyypVr-k
endfunction
