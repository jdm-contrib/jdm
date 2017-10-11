var gulp      = require("gulp"),
    fs        = require("fs"),
    rename    = require("gulp-rename"),
    del       = require("del"),
    swig      = require("gulp-swig"),
    data      = require("gulp-data"),
    jsonlint  = require("gulp-jsonlint");

var translations = JSON.parse(fs.readFileSync("_trans/_config.json")),
    rtl = ["fa", "ar"],
    sites,
    trans,
    notes;

gulp.task("jsonlint", function() {
    var prev = null;
    var sitesSet = new Set();
    JSON.parse(fs.readFileSync("sites.json")).forEach(function(site) {
        var name = site.name.toUpperCase().replace(/^the\s+/i, "");

        // Check for unsorted entries
        if (prev && prev > name) {
            throw "Sites must be listed in alphanumeric order. " + prev + " needs to come after " + name;
        }
        prev = name;

        // Check for duplicate entries
        if (sitesSet.has(name)) {
            throw name + " already exists on the list.";
        }
        sitesSet.add(name);
    });

    gulp.src("sites.json")
        .pipe(jsonlint())
        .pipe(jsonlint.reporter());
});

gulp.task("clean", function(callback) {
    return del(["docs/*.html"], callback);
});

gulp.task("translate", ["clean"], function() {

    translations.forEach(function(translation) {

        sites = JSON.parse(fs.readFileSync("sites.json"));
        trans = JSON.parse(fs.readFileSync("_trans/" + translation.code + ".json"));

        if (translation.code !== "en") {
            sites.forEach(function(site, i) {
                if (site.notes) {
                    site.notes = site["notes_"+translation.code] ? site["notes_"+translation.code] : site.notes;
                    sites[i] = site;
                }
            });
        }

        gulp.src("template.html")
            .pipe(rename((translation.code === "en" ? "index" : translation.code) + ".html"))
            .pipe(data({
                trans: translation,
                i18n: trans,
                sites,
                rtl: (rtl.indexOf(translation.code) === -1) ? false : true,
                assetPath: "assets"
            }))
            .pipe(swig())
            .pipe(gulp.dest("docs"));
    });

});

gulp.task("default", ["jsonlint", "translate"]);
