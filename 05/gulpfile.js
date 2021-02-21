const { src, dest, parallel } = require('gulp');
const concat = require('gulp-concat');
const csso = require('gulp-csso');
const fibers = require('fibers');
const sass = require('gulp-sass');
const slm = require('gulp-slm');

const config = new Map([
  [
    'src',
    new Map([
      ['scss', 'src/scss/*.scss'],
      ['slm', 'src/slm/*.slm'],
    ]),
  ],
  [
    'dest',
    new Map([
      ['css', 'public'],
      ['html', 'public'],
    ]),
  ],
]);

sass.compiler = require('sass');

css = () => {
  return src(config.get('src').get('scss'))
    .pipe(sass({ fiber: fibers }))
    .pipe(csso())
    .pipe(concat('app.min.css'))
    .pipe(dest(config.get('dest').get('css')));
};

html = () => {
  return src(config.get('src').get('slm'))
    .pipe(slm())
    .pipe(dest(config.get('dest').get('html')));
};

exports.css = css;
exports.html = html;
exports.default = parallel(html, css);
