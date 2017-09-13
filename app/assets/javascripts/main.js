$(document).on('turbolinks:load', ready);

function ready() {
    var edit_form;

    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();

    var el = document.getElementById('edit_text_1');
    var sortable = Sortable.create(el);
    console.log('dion')
}