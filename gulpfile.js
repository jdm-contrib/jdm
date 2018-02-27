var gulp         = require("gulp"),
    fs           = require("fs"),
    rename       = require("gulp-rename"),
    del          = require("del"),
    swig         = require("gulp-swig"),
    data         = require("gulp-data"),
    jsonlint     = require("gulp-jsonlint"),
    lintspaces   = require("gulp-lintspaces"),
    sanitizeHtml = require("sanitize-html");

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

        // With <a> tags in notes allowed, escape all HTML and character entities
        sites = sites.map(function(site) {
            var strictSanitizeOptions = {
                allowedTags: [],
                allowedAttributes: [],
            },
            allowLinksSanitizeOptions = {
                allowedTags: ["a"],
                allowedAttributes: {
                    "a": ["href"],
                },
            };
            /* eslint-disable security/detect-object-injection */
            Object.keys(site).forEach(function(key) {
                if (key.startsWith("notes")) {
                    site[key] = sanitizeHtml(site[key], allowLinksSanitizeOptions);
                } else {
                    site[key] = sanitizeHtml(site[key], strictSanitizeOptions);
                }
            });
            /* eslint-enable security/detect-object-injection */
            return site;
        });

        gulp.src("template.html")
            .pipe(rename((translation.code === "en" ? "index" : translation.code) + ".html"))
            .pipe(data({
                trans: translation,
                i18n: trans,
                sites,
                rtl: (rtl.indexOf(translation.code) === -1) ? false : true,
                assetPath: "assets"
            }))
            .pipe(swig({
                defaults: {
                    autoescape: false,
                }
            }))
            .pipe(gulp.dest("docs"));
    });

});

gulp.task("lintspaces", function() {
    gulp.src([
        "**/*",             // include all files
        "!**/*.png",        // exclude images
        "!**/libs/**/*",    // exclude library files
        "!node_modules/**", // exclude node_modules files
        "!LICENSE.md",      // exclude LICENSE file
    ])
        .pipe(lintspaces({
            editorconfig: ".editorconfig",
        }))
        .pipe(lintspaces.reporter({
            breakOnWarning: true,
        }));
});

gulp.task("default", ["jsonlint", "translate", "lintspaces"]);
