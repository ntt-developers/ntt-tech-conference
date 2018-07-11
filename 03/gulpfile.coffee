gulp = require('gulp')
$ = require('gulp-load-plugins')()

app = '.'
src = app + '/src'
modules = app + '/node_modules'
config =
  input:
    slim: src + '/slim/*.slim'
    scss: src + '/scss/*.scss'
    coffee: src + '/coffee/*.coffee'
  node_modules:
    scss: [ modules + '/bootstrap/**/*.scss', modules + '/bootswatch/dist/lumen/bootstrap.css', modules + '/font-awesome/scss/*.scss' ]
    js: [ modules + '/jquery/dist/jquery.js', modules + '/bootstrap/dist/js/bootstrap.js' ]
    font: [ modules + '/font-awesome/fonts/fontawesome-webfont.*' ]
  output:
    html: app + '/'
    css: app + '/assets/stylesheets/'
    js: app + '/assets/javascripts/'
    font: app + '/assets/fonts/'

gulp.task 'slim', ->
  gulp.src(config.input.slim)
    .pipe($.slim({
                   pretty: true,
                   require: 'slim/include',
                   options: 'include_dirs=["./src/slim"]'
                 }))
    .pipe(gulp.dest(config.output.html))

gulp.task 'scss', ->
  gulp.src(config.input.scss)
    .pipe($.sass())
    .pipe($.concat('application.min.css'))
    .pipe($.minifyCss({ keepSpecialComments: 0 }))
    .pipe(gulp.dest(config.output.css))

gulp.task 'coffee', ->
  gulp.src(config.input.coffee)
    .pipe($.coffee({ bare: true }))
    .pipe($.concat('application.min.js'))
    .pipe($.uglify())
    .pipe(gulp.dest(config.output.js))

gulp.task 'modules_scss', ->
  gulp.src(config.node_modules.scss)
    .pipe($.sass())
    .pipe($.concat('modules_components.min.css'))
    .pipe($.minifyCss({ keepSpecialComments: 0 }))
    .pipe(gulp.dest(config.output.css))

gulp.task 'modules_js', ->
  gulp.src(config.node_modules.js)
    .pipe($.concat('modules_components.min.js'))
    .pipe($.uglify())
    .pipe(gulp.dest(config.output.js))

gulp.task 'modules_font', ->
  gulp.src(config.node_modules.font)
    .pipe(gulp.dest(config.output.font))

gulp.task 'watch', ->
  gulp.watch(config.input.slim, ['slim'])
  gulp.watch(config.input.scss, ['scss'])
  gulp.watch(config.input.coffee, ['coffee'])

gulp.task 'webserver', ->
  gulp.src(app)
    .pipe($.webserver({ host: '0.0.0.0' }))

gulp.task 'default', [
  'slim',
  'scss',
  'coffee',
  'modules_scss',
  'modules_js',
  'modules_font'
]

gulp.task 'development', [
  'webserver',
  'watch'
]
