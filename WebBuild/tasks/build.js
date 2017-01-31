var gulp = require('gulp');

gulp.task('build', ['review-js', 'build-javascript', 'build-css', 'cp-fonts']);