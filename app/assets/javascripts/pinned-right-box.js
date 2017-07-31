$(document).on('turbolinks:load', ready);
function ready() {
    console.log('happened');
    $('.original').affix({
        offset: {
            top: 50,
            bottom: function () {
                return (this.bottom = $('.footer').outerHeight(true))
            }
        }
    });
}