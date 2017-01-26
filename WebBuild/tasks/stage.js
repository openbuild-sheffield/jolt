var gulp = require('gulp');
var concat = require('gulp-concat');
var fs = require('fs');
var path = require('path');
var paths = require('../paths');
var del = require('del');

var date_string = new Date().toISOString().replace(/T/, '-').replace(/\..+/, '').replace(/:/g, '-');

function getThemeDirs(dir) {
    return fs.readdirSync(dir)
      .filter(function(file) {
        return fs.statSync(path.join(dir, file)).isDirectory();
      });
}

gulp.task('release', ['release-js', 'release-css', 'release-theme']);

gulp.task('release-js', function() {

    return gulp.src([paths.output + 'javascript/app.js'])
    .pipe(concat('app-' + date_string + '.js'))
    .pipe(gulp.dest(paths.output + 'javascript'));

});

gulp.task('release-css', function() {

    return gulp.src([paths.output + 'css/style.css'])
    .pipe(concat('style-' + date_string + '.css'))
    .pipe(gulp.dest(paths.output + 'css'));

});

gulp.task('release-theme', function() {

    var themeDirs = getThemeDirs(paths.themes);

    var tasks = themeDirs.map(function(dir) {
        var dest = paths.themes + '/' + dir + '/js-and-style.html';
        fs.writeFileSync(dest, '<script src="/javascript/app-'+date_string+'.js"></script>\n<link rel="stylesheet" type="text/css" href="/css/style-'+date_string+'.css">');
    });

    return tasks;

});

gulp.task('dev', ['dev-theme', 'dev-remove-release', 'build']);

gulp.task('dev-theme', function() {

    var themeDirs = getThemeDirs(paths.themes);

    var tasks = themeDirs.map(function(dir) {
        var dest = paths.themes + '/' + dir + '/js-and-style.html';
        fs.writeFileSync(dest, '<script src="/javascript/app.js"></script>\n<link rel="stylesheet" type="text/css" href="/css/style.css">');
    });

    return tasks;

});

gulp.task('dev-remove-release', function() {
    return del([
        paths.output + 'css/style-*.css',
        paths.output + 'javascript/app-*.js'
    ]);
});