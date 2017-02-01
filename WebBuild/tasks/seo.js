var gulp = require('gulp');
var request = require('request');
var uris = require('../uris');

gulp.task('seo', function() {

    request('http://www.google.com/webmasters/tools/ping?sitemap=' + uris.site_map, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log("")
            console.log("SEO submitted google success")
            console.log(body);
        } else {
            console.log("SEO error google")
            console.log(response)
            console.log(body)
        }
    });

    request('http://www.bing.com/webmaster/ping.aspx?siteMap=' + uris.site_map, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log("")
            console.log("SEO submitted bing success")
            console.log(body);
        } else {
            console.log("SEO error google")
            console.log(response)
            console.log(body)
        }
    });

});