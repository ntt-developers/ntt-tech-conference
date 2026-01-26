const { src, dest, parallel, watch } = require("gulp");
const concat = require("gulp-concat");
const connect = require("gulp-connect");
const csso = require("gulp-csso");
const fs = require("fs");
const sass = require("gulp-sass")(require("sass"));
const slm = require("gulp-slm");
const uglify = require("gulp-uglify");
const yaml = require("js-yaml");

const config = new Map([
  ["data", new Map([["path", "src/yaml/data.yaml"]])],
  [
    "dest",
    new Map([
      ["css", "public"],
      ["js", "public"],
      ["html", "public"],
    ]),
  ],
  [
    "sass",
    new Map([
      [
        "options",
        {
          includePaths: "./node_modules/",
        },
      ],
    ]),
  ],
  [
    "src",
    new Map([
      ["js", "src/js/**/*.js"],
      ["scss", "src/scss/**/*.scss"],
      ["slm", "src/slm/**/*.slm"],
      ["yaml", "src/yaml/**/*.yaml"],
    ]),
  ],
]);

css = () => {
  return src(config.get("src").get("scss"))
    .pipe(sass(config.get("sass").get("options")))
    .pipe(concat("app.min.css"))
    .pipe(csso())
    .pipe(dest(config.get("dest").get("css")));
};

js = () => {
  return src(config.get("src").get("js"))
    .pipe(concat("app.min.js"))
    .pipe(uglify())
    .pipe(dest(config.get("dest").get("js")));
};

html = () => {
  const data = yaml.load(
    fs.readFileSync(config.get("data").get("path"), "utf8")
  );

  return src(config.get("src").get("slm"))
    .pipe(slm({ locals: data }))
    .pipe(dest(config.get("dest").get("html")));
};

preview = () => {
  watch(config.get("src").get("js"), js);
  watch(config.get("src").get("scss"), css);
  watch([config.get("src").get("slm"), config.get("src").get("yaml")], html);
};

server = () => {
  connect.server({
    livereload: true,
    root: "public",
  });
};

exports.css = css;
exports.js = js;
exports.html = html;

exports.default = parallel(css, js, html);
exports.preview = parallel(preview, server);
