BCPinner = (function () {
    return {
        pin: function pin_original() {
            $('.original').affix({
                offset: {
                    top: 50,
                    bottom: function () {
                        return (this.bottom = $('.footer').outerHeight(true))
                    }
                }
            });
        }
    }
}());