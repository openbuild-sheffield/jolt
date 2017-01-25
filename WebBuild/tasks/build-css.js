var concat = require('gulp-concat');
var gulp = require('gulp');
var paths = require('../paths');
var sass = require('gulp-sass');

gulp.task('build-css', function () {
    return gulp.src(paths.style)
        .pipe(sass().on('error', sass.logError))
        .pipe(concat('style.css'))
        .pipe(gulp.dest(paths.output + 'css'));
});