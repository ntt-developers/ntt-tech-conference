gulp = require('gulp')
mainBowerFiles = require('main-bower-files')
$ = require('gulp-load-plugins')()

app = '.'
src = app + '/src'
config =
  input:
    slim: src + '/slim/*.slim'
    scss: src + '/scss/*.scss'
    coffee: src + '/coffee/*.coffee'
    font: app + '/bower_components/fontawesome/fonts/fontawesome-webfont.*'
  output:
    html: app + '/'
    css: app + '/assets/stylesheets/'
    js: app + '/assets/javascripts/'
    font: app + '/assets/fonts/'

gulp.task 'slim', ->
  gulp.src(config.input.slim)
    .pipe($.slim({ pretty: true }))
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

gulp.task 'bower_scss', ->
  gulp.src(mainBowerFiles({ filter: '**/*.scss' }))
    .pipe($.sass())
    .pipe($.concat('bower_components.min.css'))
    .pipe($.minifyCss({ keepSpecialComments: 0 }))
    .pipe(gulp.dest(config.output.css))

gulp.task 'bower_js', ->
  gulp.src([mainBowerFiles({ filter: '**/jquery.js' })..., mainBowerFiles({ filter: '**/tether.js' })..., mainBowerFiles({ filter: '**/bootstrap.js' })...])
    .pipe($.concat('bower_components.min.js'))
    .pipe($.uglify())
    .pipe(gulp.dest(config.output.js))

gulp.task 'bower_font', ->
  gulp.src(config.input.font)
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
  'bower_scss',
  'bower_js',
  'bower_font'
]

gulp.task 'development', [
  'webserver',
  'watch'
]
