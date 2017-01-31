var gulp = require('gulp');
var fs = require('fs');
var path = require('path');
var paths = require('../paths');

function getFontFiles(startPath, extensions){

    var results = [];

    if (!fs.existsSync(startPath)){
        console.log("no dir ",startPath);
        return;
    }

    var files=fs.readdirSync(startPath);

    for(var i=0;i<files.length;i++){

        var filename=path.join(startPath,files[i]);
        var stat = fs.lstatSync(filename);

        if (stat.isDirectory()){
            results = results.concat(getFontFiles(filename,extensions)); //recurse
        } else {

            var extension = path.extname(filename)

            if(extensions.indexOf(extension) >= 0){
                results.push(filename);
            }

        }

    }

    return results;

}

gulp.task('cp-fonts', function() {

    var fontFiles = getFontFiles(paths.jspm, [".otf",".eot",".ttf",".woff",".woff2",".svg"]);

    return gulp.src(fontFiles)
    .pipe(gulp.dest(paths.output + '/fonts/'));

});
