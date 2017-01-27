var gulp  = require('gulp')
var shell = require('gulp-shell')

gulp.task('build-swift-dev', shell.task([
  'swift build'
]))

gulp.task('build-swift-dev', shell.task([
  'swift build'
]))

gulp.task('build-swift-release', shell.task([
  'swift build -c release'
]))