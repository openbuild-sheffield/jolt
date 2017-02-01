var concat = require('gulp-concat');
var gulp = require('gulp');
var paths = require('../paths');
var sass = require('gulp-sass');

gulp.task('build-css', function () {
    return gulp.src([paths.root + 'sass/_jspm/**/*.scss', paths.root + 'sass/site/**/*.scss'])
        .pipe(sass().on('error', sass.logError))
        .pipe(concat('style.css'))
        .pipe(gulp.dest(paths.output + 'css'));
});