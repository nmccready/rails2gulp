jasminePhantomJs = require('gulp-jasmine2-phantomjs')
open         = require("gulp-open")

module.exports = (gulp, log, concat, size, minify, rename, coffee, gulpif, myClean, bang = '!!!!!!!!!!') ->
  log "#{bang}Jasmine Setup#{bang}"
  ###
  this file should be called by gulpfile.coffee
  with gulp and plugins already loaded
  ###
  jasmine = "jasmine"
  jasmineBuild = "jasmine" + "_build"
  jasmine2JUnit= "jasmine2-junit"
  dependencies = [jasmine,jasmine2JUnit]

  log "#{bang} BEGIN: Jasmine Tasks#{bang}"
  dependencyTasks = {}
  dependencies.forEach (t) ->
    dependencyTasks[t] = t + "_build"
    log dependencyTasks[t]

  log "#{bang} END: Jasmine Tasks: #{dependencyTasks}#{bang}"

  jasmineFiles = [
    "jasmine"
    "jasmine-html"
  ]
  bowerJasmineFiles = jasmineFiles.map (v) ->
    v = "app/components/#{jasmine}/lib/jasmine-core/#{v}".js()
    log v
    v
  bowerJasmineFiles = bowerJasmineFiles.concat [
    "app/components/#{jasmine}/lib/jasmine-core/jasmine.css"
    "app/components/#{jasmine2JUnit}/boot.js"
    "app/components/#{jasmine2JUnit}/#{jasmine2JUnit}.js"
    "app/components/#{jasmine}/lib/console/console.js"
    #support fixtures
    "app/components/jasmine-jquery/lib/jasmine-jquery.js"
    "lib/jasmine*"
    "app/spec/spec_runner.html"
  ]

  log "#{bang} BEGIN: TASK: #{dependencyTasks[jasmine]}#{bang}"
  gulp.task dependencyTasks[jasmine], ->
    log "#{bang}Loading #{dependencyTasks[jasmine]}#{bang}"
    #clean up old jasmine files in dist
    jasmineFiles.forEach (f) ->
      myClean("dist/#{f.js()}")
    #copy jasmine dependencies to dist
    gulp.src(bowerJasmineFiles)
    .pipe(gulpif(/[.]coffee$/, coffee().on('error',log)))
    .pipe(size())
    .pipe(gulp.dest("dist"))

  gulp.task dependencyTasks[jasmine2JUnit], ->
    log "#{bang}Loading #{dependencyTasks[jasmine2JUnit]}#{bang}"
    myClean("dist/#{jasmine2JUnit.js()}")
    gulp.src("app/components/#{jasmine2JUnit}/#{jasmine2JUnit.js()}")
    .pipe(size())
    .pipe(gulp.dest("dist"))

  gulp.task jasmine, ["jasmine_build","sass","templates",
  "vendor_develop","scripts","spec_build_jasmine",
  "serve-build"],->
    options =
      url: "http://localhost:3000/jasmine.html"
      app: "Google Chrome" #osx , linux: google-chrome, windows: chrome
    gulp.src("dist/spec_runner.html")
    .pipe(rename("jasmine.html"))
    .pipe(gulp.dest("dist"))
    .pipe(open("", options))

  spec: jasmine
  dependencies: dependencies
  dependencyTasks: dependencyTasks
  runner: jasminePhantomJs
