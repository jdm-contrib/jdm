function onRootPage() {
    const path = window.location.pathname;
    const isRoot = path === '/' || path === '' || path === '/index.html' || path === '/index';
    return isRoot;
}

function getLanguageMatch(language) {
    if (!language) {
        return null;
    }
    const available = window.availableLanguages;
    const baseLanguage = language.slice(0, 2);
    return available.find(item => item === language || item.startsWith(baseLanguage));
}

if (onRootPage()) {
    const language = navigator.language || navigator.userLanguage;
    const match = getLanguageMatch(language);
    if (match) {
        window.location.href = `/${match}`;
    }
}
