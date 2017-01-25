var concat = require('gulp-concat');
var gulp = require('gulp');
var paths = require('../paths');

gulp.task('build-javascript', function () {
    return gulp.src(paths.javascript)
        .pipe(concat('app.js'))
        .pipe(gulp.dest(paths.output + 'javascript'));
});