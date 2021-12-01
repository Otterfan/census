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
        const googleAnalyticsID = '';
        const script = document.createElement("script");
        script.innerHTML = "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){" +
            "(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o)," +
            "m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)" +
            "})(window,document,'script','//www.google-analytics.com/analytics.js','ga');" +
            "ga('create', '" + googleAnalyticsID + "', 'auto');" + "ga('send', 'pageview');";
        document.head.appendChild(script);
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