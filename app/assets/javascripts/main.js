$(document).on('turbolinks:load', ready);

function ready() {
    var edit_form;

    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();
}