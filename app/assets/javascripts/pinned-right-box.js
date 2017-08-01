BCPinner = (function () {
    return {
        pin: function pin_original() {
            console.log('pinned');
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