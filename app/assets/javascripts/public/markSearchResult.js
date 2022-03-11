jQuery.fn.markSearchResult = function() {
    const stopWords = ['a', 'the', 'of', 'in', 'and', 'to'];

    // https://stackoverflow.com/a/21903119
    function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    }

    function purgeStopWords(inputString) {
        const parts = inputString.toLowerCase().split(' ');
        return parts.filter(word => !stopWords.includes(word)).join(' ');
    }

    var separate_word_search = true;
    var hl = getUrlParameter("hl");

    if (hl && hl !== 'undefined') {
        // decode HTML param
        // and convert HTML encoded spaces back into text spaces
        hl = decodeURI(hl).replace(/\+/g, ' ');

        // handle quoted search strings
        if (hl.indexOf('"') === 0) {
            separate_word_search = false;
            hl = hl.replace(/^"/, '').replace(/"$/, '');
        }

        // Remove stopwords.
        hl = purgeStopWords(hl);


        // trigger mark.js instance with hl
        if (hl.length > 0) {
            $("main.container").mark(hl, {
                "element": "mark",
                "className": "highlight",
                "exclude": ["dt"],
                "separateWordSearch": separate_word_search
            });
        }
    }
}
