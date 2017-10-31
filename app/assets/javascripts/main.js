$(document).on('turbolinks:load', ready);

function ready() {
    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();

    var el = document.getElementsByTagName('form');
    var sortable = Sortable.create(el[0]);

    var comment_form = $('#new-comment-form');
    comment_form.submit(function (event) {
        event.preventDefault();
        BCComments.add();
        return false;
    });

    $('#collapse-original-button').click(function () {
        console.log('happened');
        $('#collapse-original-button span').toggleClass('glyphicon-collapse-down glyphicon-collapse-up');
    });
}