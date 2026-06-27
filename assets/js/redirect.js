function onRootPage() {
    const path = window.location.pathname;
    const isRoot = path === '/' || path === '' || path === '/index.html' || path === '/index';
    return isRoot;
}

function getLanguageMatch(language) {
    const available = Array.isArray(window.AVAILABLE_LANGUAGES) ? window.AVAILABLE_LANGUAGES : [];
    if (!language || !available.length) {
        return null;
    }

    const exactMatch = available.find(item => item === language);
    if (exactMatch) {
        return exactMatch;
    }

    const baseLanguage = language.split('-')[0];
    return available.find(item => item.split('-')[0] === baseLanguage) || null;
}

if (onRootPage()) {
    const language = navigator.language || navigator.userLanguage;
    const match = getLanguageMatch(language);
    if (match) {
        window.location.href = `/${match}`;
    }
}
