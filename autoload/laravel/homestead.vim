" autoload/laravel/homestead.vim - Laravel Homestead support for Vim
" Maintainer: Noah Frederick

""
" @setting g:laravel_homestead_dir
" The directory where Homestead is installed.
let s:dir = get(g:, 'laravel_homestead_dir', '~/Homestead')
let s:json = s:dir . '/Homestead.json'

""
" Change working directory to {dir}, respecting current window's local dir
" state. Returns old working directory to be restored later by a second
" invocation of the function.
function! s:cd(dir) abort
  let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd' : 'cd'
  let cwd = getcwd()
  execute cd fnameescape(a:dir)
  return cwd
endfunction

""
" Escape arguments to be passed to ssh.
function! s:prepare_args(args) abort
  return shellescape(join(a:args))
endfunction

""
" Build SSH shell command from command-line arguments.
function! s:ssh(args) abort
  let root = laravel#app().homestead_root()

  if empty(root)
    echoerr 'Homestead site not configured for ' . laravel#app().path()
  endif

  if empty(a:args)
    return 'vagrant ssh'
  endif

  let args = insert(a:args, 'cd ' . root . ' &&')
  return 'vagrant ssh -- ' . s:prepare_args(args)
endfunction

""
" Build Vagrant shell command from command-line arguments.
function! s:vagrant(args) abort
  if empty(a:args)
    return 'vagrant status'
  endif

  return 'vagrant ' . join(a:args)
endfunction

""
" The :Homestead command.
function! laravel#homestead#exec(...) abort
  let args = copy(a:000)
  let vagrant = remove(args, 0)

  if !isdirectory(s:dir)
    echoerr 'Homestead directory does not exist: ' . s:dir
          \ . ' (set g:laravel_homestead_dir)'
  endif

  let cmdline = vagrant ==# '!' ? s:vagrant(args) : s:ssh(args)

  if exists(':terminal')
    tabedit %
    execute 'lcd' fnameescape(s:dir)
    execute 'terminal' cmdline
  else
    let cwd = s:cd(s:dir)
    execute '!' . cmdline
    call s:cd(cwd)
  endif

  return ''
endfunction

function! laravel#homestead#root(app_root) abort
  " TODO: Read homestead.json configuration file instead:
  return get(get(g:, 'laravel_homestead_sites', {}), a:app_root, '')
endfunction

""
" @private
" Hack for testing script-local functions.
function! laravel#homestead#sid()
  nnoremap <SID> <SID>
  return maparg('<SID>', 'n')
endfunction

" vim: fdm=marker:sw=2:sts=2:et
