var gulp = require('gulp');
var watch = require('gulp-watch');
var batch = require('gulp-batch');
var paths = require('../paths');

gulp.task('watch', function () {
    watch(paths.style, batch(function (events, done) {
        gulp.start('build-css', done);
    }));
    gulp.watch(paths.javascript, ['review-js', 'build-javascript']);
});

