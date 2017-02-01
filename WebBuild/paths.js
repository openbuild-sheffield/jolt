var path = require('path');

var appRoot = 'WebSource/';
var outputRoot = 'Public/';

module.exports = {
  root: appRoot,
  javascript: appRoot + 'javascript/**/*.js',
  javascriptLib: appRoot + 'javascript/_libs.js',
  style: appRoot + 'sass/**/*.scss',
  jspm: appRoot + 'jspm_packages',
  output: outputRoot,
  sourceMapRelativePath: '../' + appRoot,
  themes: 'Themes',
  jspmSassDest: appRoot + 'sass/_jspm'
};