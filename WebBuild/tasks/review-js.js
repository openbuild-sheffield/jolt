var gulp = require('gulp');
var jshint = require('gulp-jshint');
var paths = require('../paths');

gulp.task('review-js', function() {
    return gulp.src(paths.javascript)
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
});