$(document).on('turbolinks:load', ready);

function ready() {
    var edit_form;

    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();

    var el = document.getElementsByTagName('form');
    var sortable = Sortable.create(el[0]);
}