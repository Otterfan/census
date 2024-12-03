class CoookieBar {
    constructor() {
        this.cookiesBar = document.getElementById('cookies-bar');
        this.modal = document.getElementById('cookies-modal');
        this.initialized =false;
    }

    init() {
        if (this.cookiesAllowed()) {
            this.appendGACode();
        }

        this.addButtonBehaviors();
    }

    cookiesAllowed() {
        return Cookies.get('allow_cookies') === 'yes';
    }

    addButtonBehaviors() {
        if (!this.cookiesBar) {
            return;
        }

        this.cookiesBar.querySelector('.cookie-bar__accept').addEventListener('click', () => this.allowCookies());
        this.cookiesBar.querySelector('.cookie-bar__reject').addEventListener('click', () => this.disallowCookies());
    }

    appendGACode() {
        const ga4Html = '<script async src="https://www.googletagmanager.com/gtag/js?id=G-5ZT2TXDZRY"></script>\n' +
            '<script>' +
            '  window.dataLayer = window.dataLayer || [];\n' +
            '  function gtag(){dataLayer.push(arguments);}\n' +
            '  gtag(\'js\', new Date());\n' +
            '\n' +
            '  gtag(\'config\', \'G-5ZT2TXDZRY\');\n' +
            '</script>';
        document.head.insertAdjacentHTML('beforeend', ga4Html);
    }

    allowCookies() {
        Cookies.set('allow_cookies', 'yes', {expires: 365});
        this.appendGACode();
        this.modal.classList.add('hidden');
    }

    disallowCookies() {
        Cookies.set('allow_cookies', 'no', {expires: 365});
        this.modal.classList.add('hidden');
    }
}

// Loader
function censusHasLoaded() {
    const cookieBar = new CoookieBar();
    cookieBar.init();
}

$(document).on('turbolinks:load', censusHasLoaded)