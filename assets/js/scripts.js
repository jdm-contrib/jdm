$(function(){
    // Helper function to show all except filtered sites
    // Accepts a function which returns true for $(".site-block") elements
    // matching desired qualifications
    function hideFilteredSites(filterFunction) {
        var $sites = $(".sites section");
        $sites.show().filter(filterFunction).hide();
        if ( ! $(".site-block").is(":visible")) {
            $(".no-results").show();
        }
    }

    function setWindowHash(value) {
        window.location.hash = value;
    }

    function getDecodedWindowHash() {
        return decodeURIComponent(window.location.hash);
    }

    // Search function
    function updateSearch() {
        if ($(".no-results").is(":visible")) {
            $(".no-results").hide();
        }

        var hash = getDecodedWindowHash();
        var term = hash.substr(1);

        hideFilteredSites(function() {
            var siteHeader = $(this).find(".site-header")[0];
            var siteTitle = siteHeader.innerText.trim().toLowerCase();
            var siteUrl = siteHeader.href.toLowerCase();
            var lowerTerm = term.toLowerCase();

            // returns true if lowerTerm isn't found in site title or URL
            return Math.max(siteTitle.indexOf(lowerTerm), siteUrl.indexOf(lowerTerm)) === -1;
        });

        // Insert the term into the search field
        // (sometimes this is missed if the hash is changed directly)
        $("#search").val(term);
    }

    $("body").addClass("js-on");

    // A - Z filtering
    $(".alpha-sort a").click(function(e){
        e.preventDefault();
        var term = $(this).text().toLowerCase();

        hideFilteredSites(function() {
            var text = $(this).find(".site-header").text().trim().toLowerCase().substr(0,1);
            return !~text.indexOf(term);
        });
    });

    // Difficulty filtering
    $(".diff-sort a").click(function(e){
        e.preventDefault();
        var term = $(this).text().toLowerCase();

        hideFilteredSites(function() {
            var text = $(this).find(".site-difficulty").text().trim().toLowerCase();
            return !~text.indexOf(term);
        });
    });

    // Popular filtering
    $("button.popular").click(function(e){
        e.preventDefault();
        var term = "popular";

        hideFilteredSites(function() {
            return typeof $(this)[0].dataset["popular"] === "undefined";
        });
    });

    // Clear search and filtering
    $("button.reset").click(function(e){
        var $sites = $(".sites section");
        $sites.show();
        $(".no-results").hide();
        $("input").val("");
        if (window.location.href.includes("#") && getDecodedWindowHash()) {
            setWindowHash("");
        }
    });

    // Toggle visibility of site info boxes
    $(".contains-info").click(function(e) {
        e.preventDefault();
        if ($(this).prev().hasClass("toggled")) {
            $(this).prev().slideToggle().removeClass("toggled");
        } else {
            $(".toggled").slideToggle().removeClass("toggled");
            $(this).prev().slideToggle().addClass("toggled");
        }
    });

    // When the search field changes, update the hash
    var hashUpdateTimer;
    $("input").on("input", function(){
        window.clearTimeout(hashUpdateTimer);
        hashUpdateTimer = setTimeout(setWindowHash, 250, $(this).val());
    });

    // When the user hits enter while in the search bar, update the hash immediately and clear the
    // debounce timeout
    $("input").on("keypress", function(e) {
        var code = e.keyCode || e.which;
        if (code === 13) { // Enter key
            window.clearTimeout(hashUpdateTimer);
            setWindowHash($(this).val());
        }
    });

    // Call updateSearch when hash changes
    $(window).on("hashchange", function() {
        updateSearch();
    });

    // Update search results on page load (if there is a hash)
    if (getDecodedWindowHash() && getDecodedWindowHash() !== "#") {
        // Insert the term into the field
        $("#search").val(getDecodedWindowHash().substr(1));

        // Update the results
        updateSearch();
    }

    // jQuery ScrollTo plugin from http://lions-mark.com/jquery/scrollTo/

    $.fn.scrollTo = function(target, options, callback ) {
        if(typeof options === "function" && arguments.length === 2){ callback = options; options = target; }
        var settings = $.extend({
            scrollTarget  : target,
            offsetTop     : 50,
            duration      : 500,
            easing        : "swing"
        }, options);
        return this.each(function() {
            var scrollPane = $(this);
            var scrollTarget = (typeof settings.scrollTarget === "number") ? settings.scrollTarget : $(settings.scrollTarget);
            var scrollY = (typeof scrollTarget === "number") ? scrollTarget : scrollTarget.offset().top + scrollPane.scrollTop() - parseInt(settings.offsetTop);
            scrollPane.animate({scrollTop : scrollY }, parseInt(settings.duration), settings.easing, function(){
                if (typeof callback === "function") { callback.call(this); }
            });
        });
    };

    // Banner scroll to bottom
    $(".banner").click(function(e) {
        e.preventDefault();
        $("body,html").scrollTo(".banner-block");
    });
    $(".info").click(function(e) {
        e.preventDefault();
        $("body,html").scrollTo(".about");
    });

    // Auto-focus search field on load
    $("#search").focus();
});
