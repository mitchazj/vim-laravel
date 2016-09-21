" autoload/laravel/projectionist.vim - Projections for Laravel projects
" Maintainer: Noah Frederick

if !exists('g:projectionist_transformations')
  let g:projectionist_transformations = {}
endif

function! g:projectionist_transformations.namespace(input, o) abort
  return laravel#app().namespace(expand('%'))
endfunction

function! laravel#projectionist#append() abort
  let projections = {
        \ "*": {
        \   "start": "homestead ssh",
        \   "console": [laravel#app().makeprg(), 'tinker'],
        \   "framework": "laravel",
        \ },
        \ "bootstrap/*.php": {
        \   "type": "bootstrap",
        \ },
        \ "config/*.php": {
        \   "type": "config",
        \   "template": [
        \     "<?php",
        \     "",
        \     "return [",
        \     "    //",
        \     "];",
        \   ],
        \ },
        \ "config/app.php": {
        \   "type": "config",
        \ },
        \ "app/*.php": {
        \   "type": "lib",
        \   "template": [
        \     "<?php",
        \     "",
        \     "namespace {namespace};",
        \     "",
        \     "class {basename}",
        \     "{open}",
        \     "    //",
        \     "{close}",
        \   ],
        \ },
        \ "app/Http/Controllers/*.php": {
        \   "type": "controller",
        \   "template": [
        \     "<?php",
        \     "",
        \     "namespace {namespace};",
        \     "",
        \     "class {basename} extends Controller",
        \     "{open}",
        \     "    //",
        \     "{close}",
        \   ],
        \ },
        \ "app/Http/Controllers/Controller.php": {
        \   "type": "controller",
        \ },
        \ "app/Http/Middleware/*.php": {
        \   "type": "middleware",
        \ },
        \ "app/Http/Kernel.php": {
        \   "type": "middleware",
        \ },
        \ "app/Http/Requests/*.php": {
        \   "type": "request",
        \ },
        \ "app/Events/*.php": {
        \   "type": "event",
        \   "alternate": "app/Listeners/{}.php",
        \ },
        \ "app/Events/Event.php": {
        \   "type": "event",
        \ },
        \ "app/Exceptions/*.php": {
        \   "type": "exception",
        \ },
        \ "app/Exceptions/Handler.php": {
        \   "type": "exception",
        \ },
        \ "app/Providers/*.php": {
        \   "type": "provider",
        \ },
        \ "database/factories/*.php": {
        \   "type": "factory",
        \ },
        \ "database/factories/ModelFactory.php": {
        \   "type": "factory",
        \ },
        \ "database/migrations/*.php": {
        \   "type": "migration",
        \ },
        \ "database/seeds/*.php": {
        \   "type": "seeder",
        \ },
        \ "database/seeds/DatabaseSeeder.php": {
        \   "type": "seeder",
        \ },
        \ "tests/*.php": {
        \   "type": "test",
        \ },
        \ "tests/TestCase.php": {
        \   "type": "test",
        \   "alternate": "phpunit.xml",
        \ },
        \ "phpunit.xml": {
        \   "alternate": "test/TestCase.php",
        \ },
        \ "resources/lang/*.php": {
        \   "type": "language",
        \ },
        \ "resources/assets/*": {
        \   "type": "asset",
        \ },
        \ "resources/views/*.blade.php": {
        \   "type": "view",
        \ },
        \ "README.md": {
        \   "type": "doc",
        \ }}

  if laravel#app().has('dotenv')
    let projections[".env.example"] = {
          \   "type": "env",
          \   "alternate": ".env",
          \ }

    let projections[".env"] = {
          \   "type": "env",
          \   "alternate": ".env.example",
          \ }
  endif

  if laravel#app().has('jobs')
    let projections["app/Jobs/*.php"] = {
          \   "type": "job",
          \ }

    let projections["app/Jobs/Job.php"] = {
          \   "type": "job",
          \ }

    let projections["app/Console/Commands/*.php"] = {
          \   "type": "command",
          \ }

    let projections["app/Console/Kernel.php"] = {
          \   "type": "command",
          \ }
  elseif laravel#app().has('commands')
    let projections["app/Commands/*.php"] = {
          \   "type": "command",
          \ }

    let projections["app/Console/Commands/*.php"] = {
          \   "type": "console",
          \ }

    let projections["app/Console/Kernel.php"] = {
          \   "type": "console",
          \ }
  endif

  if laravel#app().has('listeners')
    let projections["app/Listeners/*.php"] = {
          \   "type": "listener",
          \   "alternate": "app/Events/{}.php",
          \ }
  elseif laravel#app().has('handlers')
    let projections["app/Handlers/*.php"] = {
          \   "type": "handler",
          \   "alternate": "app/Events/{}.php",
          \ }
  endif

  if laravel#app().has('models')
    let projections["app/Models/*.php"] = {
          \   "type": "model",
          \   "template": [
          \     "<?php",
          \     "",
          \     "namespace {namespace};",
          \     "",
          \     "use Illuminate\Database\Eloquent\Model;",
          \     "",
          \     "class {basename} extends Model",
          \     "{open}",
          \     "    //",
          \     "{close}",
          \   ],
          \ }
  endif

  if laravel#app().has('policies')
    let projections["app/Policies/*.php"] = {
          \   "type": "policy",
          \   "alternate": "app/Providers/AuthServiceProvider.php",
          \ }
  endif

  if laravel#app().has('routes')
    let projections["routes/*.php"] = {
          \   "type": "routes",
          \   "alternate": "app/Http/Kernel.php",
          \ }
  else
    let projections["app/Http/routes.php"] = {
          \   "type": "routes",
          \   "alternate": "app/Http/Kernel.php",
          \ }
  endif

  if laravel#app().has('traits')
    let projections["app/Traits/*.php"] = {
          \   "type": "trait",
          \   "template": [
          \     "<?php",
          \     "",
          \     "namespace {namespace};",
          \     "",
          \     "trait {basename}",
          \     "{open}",
          \     "    //",
          \     "{close}",
          \   ],
          \ }
  endif

  return projectionist#append(b:laravel_root, projections)
endfunction

" vim: fdm=marker:sw=2:sts=2:et
