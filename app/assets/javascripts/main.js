$(document).on('turbolinks:load', ready);

function ready() {
    var edit_form;

    var auth_token = $('#comment_auth_token').val();

    console.log(auth_token);


    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();
    BCComments.fetch();

    var el = document.getElementsByTagName('form');
    var sortable = Sortable.create(el[0]);

    var comment_form = $('#your_form_id');
    comment_form.submit(function(event){
        console.log('called it');
        event.preventDefault();
        BCComments.add();
        return false;
    });
}