###
Cakefile for developping

License: MIT License

Features:
  - Compile CoffeeScript files to JavaScript files
  - Compile LESS files to CSS files
  - Join CoffeeScript files to a single JavaScript file
  - Join CSS files to a single CSS file
  - Minify a single compiled JavaScript file via YUI compressor
  - Minify a single compiled CSS file via YUI compressor
  - Test CoffeeScript files via mocha

Copyright(c) 2012, hashnote.net Alisue allright reserved.
###

# --- CONFIGURE ---------------------------------------------------
NAME              = "YOUR APPLICATION NAME"
VERSION           = "0.1.0"
CS_PATH           = "./src"
JS_PATH           = "./app"
LESS_PATH         = "./src/less"
CSS_PATH          = "./public/css"
TEST_PATH         = './tests'
CS_FILES          = ['webserver']
LESS_FILES        = ['reset','style']
TEST_FILES        = ['test']
YUI_COMPRESSOR    = "~/.yuicompressor/build/yuicompressor-2.4.7.jar"
# -----------------------------------------------------------------
fs              = require 'fs'
path            = require 'path'
util            = require 'util'
{exec, spawn}   = require 'child_process'

execAsync = (command, args) ->
  proc = spawn command, args
  proc.stdout.on 'data', (data) ->
    process.stdout.write data
  proc.stderr.on 'data', (data) ->
    process.stderr.write data

# default values
options =
  watch: no

option '-v', '--verbose', 'Display full informations'
option '-w', '--watch', 'Continuously execute action'

Coffee =
  compile: (src, dst, join=false) ->
    if join
      # compile multiple coffeescripts to a javascript
      args = ['-cj', dst]
      args = args.concat(src)
      console.log "Join #{src.length} coffee files => #{dst}"
    else
      # compile a single coffeescript to a javascript
      args = ['-bco', dst, src]
      console.log "Compile #{src} => #{dst}"
    execAsync 'coffee', args
  join: (src, dst) ->
    Coffee.compile(src, dst, true)

Less =
  compile: (src, dst) ->
    args = [src, dst]
    console.log "Compile #{src} => #{dst}"
    execAsync 'lessc', args
  join: (src, dst) ->
    console.log "Join #{src.length} css files => #{dst}"
    less = require('less')
    buffer = []
    for file in src
      less.render(fs.readFileSync(file, encoding='utf8'), (e, css) ->
        buffer.push(css)
      )
    buffer = buffer.join("\n")
    fs.writeFileSync(dst, buffer)

Minify =
  minify: (src, dst) ->
    console.log "Minify #{src} => #{dst}"
    args = ['-jar', YUI_COMPRESSOR, src, '-o', dst]
    exec "java -jar #{YUI_COMPRESSOR} #{src} -o #{dst}", (err, stdout, stderr) ->
      process.stdout.write stdout
      process.stderr.write stderr

Mocha =
  test: (src) ->
    console.log "Test #{src}"
    args = ['--compilers', 'coffee:coffee-script', '-R', 'spec', '--colors']
    args = args.concat(src)
    execAsync 'mocha', args

task 'compile', 'Compile coffeescript/less files to javascript/css files', (opts) ->
  invoke 'compile:coffee'
  invoke 'compile:less'

task 'compile:coffee', 'Compile coffeescript files to javascript files', (opts) ->
  options = opts
  for filename in CS_FILES
    do (filename) ->
      src = "#{CS_PATH}/#{filename}.coffee"
      compile = ->
        Coffee.compile(src, "#{JS_PATH}")
      compile()
      if options.watch?
        fs.watchFile src, (c, p) -> compile()

task 'compile:less', 'Compile less files to css files', (opts) ->
  options = opts
  for filename in LESS_FILES
    do (filename) ->
      src = "#{LESS_PATH}/#{filename}.less"
      dst = "#{CSS_PATH}/#{filename}.css"
      compile = ->
        Less.compile(src, dst)
      compile()
      if options.watch?
        fs.watchFile src, (c, p) -> compile()

task 'join', 'Join coffeescript/less files to a single javascript/css file', (opts) ->
  invoke 'join:coffee'
  invoke 'join:less'

task 'join:coffee', 'Join coffeescript files to a single javascript file', (opts) ->
  options = opts
  src = ("#{CS_PATH}/#{filename}.coffee" for filename in CS_FILES)
  dst = "#{JS_PATH}/#{NAME}.#{VERSION}.js"
  compile = ->
    Coffee.join(src, dst)
  compile()
  if options.watch
    for filename in CS_FILES
      src = "#{CS_PATH}/#{filename}.coffee"
      fs.watchFile src, (c, p) -> compile()

task 'join:less', 'Join less files to a single css file', (opts) ->
  options = opts
  src = ("#{LESS_PATH}/#{filename}.less" for filename in LESS_FILES)
  dst = "#{CSS_PATH}/#{NAME}.#{VERSION}.css"
  compile = ->
    Less.join(src, dst)
  compile()
  if options.watch
    for filename in LESS_FILES
      src = "#{LESS_PATH}/#{filename}.less"
      fs.watchFile src, (c, p) -> compile()

task 'minify', 'Minify javascript/css file', (opts) ->
  invoke 'minify:javascript'
  invoke 'minify:css'

task 'minify:javascript', 'Minify javascript file', (opts) ->
  invoke 'join:coffee'
  src = "#{JS_PATH}/#{NAME}.#{VERSION}.js"
  dst = "#{JS_PATH}/#{NAME}.#{VERSION}.min.js"
  Minify.minify(src, dst)

task 'minify:css', 'Minify css file', (opts) ->
  invoke 'join:less'
  src = "#{CSS_PATH}/#{NAME}.#{VERSION}.css"
  dst = "#{CSS_PATH}/#{NAME}.#{VERSION}.min.css"
  Minify.minify(src, dst)

task 'test', 'Test coffeescript files', (opts) ->
  src = ("#{TEST_PATH}/#{filename}.coffee" for filename in TEST_FILES)
  compile = -> 
    Mocha.test(src)
  compile()
  if options.watch
    for filename in src
      fs.watchFile filename, (c, p) -> compile()

task 'develop', 'Continuously compile/test coffee/less files.', (opts) ->
  opts.watch = on
  invoke 'test'
  invoke 'compile:coffee'
  invoke 'compile:less'

task 'release', 'Execute test and create minified javascript/css file', (opts) ->
  opts.watch = off
  invoke 'test'
  invoke 'minify:javascript'
  invoke 'minify:css'
