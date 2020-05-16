// Wrap all this to not pollute global namespace
{
    // Generate an array of languages from page
    const JDM_LANGS = [...document.querySelectorAll('#language-dropdown > ul > li')].map(el => el.classList[0]);


    function redirectTo(lang) {
        const link = document.querySelector(`#language-dropdown > ul > li.${lang} > a`);
        if (link)
            link.click();
    }


    function guessedTranslation() {
        const langs = navigator.languages;

        for (let i=0; i < langs.length; i++) {
            let lang = langs[i];

            // user has: 'pt-BR'
            // we have:  'pt-BR'
            if (JDM_LANGS.includes(lang))
                return lang;

            // user has: 'ru-RU'
            // we have:  'ru'
            lang = lang.slice(0,2);
            if (JDM_LANGS.includes(lang))
                return lang;

            // user has: 'pt-AO' or 'pt'
            // we have:  'pt-BR'
            for (let j=0; j < JDM_LANGS.length; j++) {
                let jdm_lang = JDM_LANGS[j];
                if (jdm_lang.slice(0,2) === lang)
                    return jdm_lang;
            }
        }

        return null;
    }


    // Do redirection only one time
    if (!localStorage.getItem('langRedirectionHasDone')) {
        localStorage.setItem('langRedirectionHasDone', true);
        redirectTo(guessedTranslation());
    }
}
