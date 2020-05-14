// Wrap all this to not pollute global namespace
{
    // Generate an array of languages from page
    // TODO: is there a way to do it static using Jekyll?
    const JDM_LANGS = [...document.querySelectorAll('#language-dropdown > ul > li')].map(el => el.classList[0]);


    function setLanguage(lang) {
        path = lang;
        // English is mounted on '/'
        if (lang === 'en')
            path = '';

        location = location.origin+'/'+path;
    }


    function _tryLanguage(lang) {
        if (JDM_LANGS.includes(lang))
            setLanguage(lang);
    }


    function tryLanguage(lang) {
        _tryLanguage(lang);

        // Test first two chars. Maybe we have not local, but more common language?
        lang = lang.slice(0,2);
        _tryLanguage(lang);
    }


    function tryLanguages() {
        // We don't have to handle returns from `tryLanguage' because of
        // this function does redirect if language considered good
        navigator.languages.forEach(tryLanguage);
    }


    // Do redirection only one time
    if (!localStorage.getItem('langRedirectionHasDone')) {
        localStorage.setItem('langRedirectionHasDone', true);
        tryLanguages();
    }
}
