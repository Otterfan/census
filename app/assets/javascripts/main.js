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


    function upload_orginal() {
        var pathArray = window.location.pathname.split('/');


        var original_text = tinymce.activeEditor.getContent(),
            post_address = '/texts/' + pathArray[2] + '/original';
        $.post(post_address, {original: original_text}, function (data) {
            console.log('success!!');
        });
    }

    if (typeof tinyMCE != 'undefined') {
        var content_style = '.small-text {font-size: small}';

        var opts = {
            selector: '.original-box textarea',
            menubar: false,
            plugins: 'save',
            toolbar: 'bold italic styleselect | removeformat | save',
            content_style: content_style,
            style_formats: [
                {title: 'Small', inline: 'span', classes: 'small-text'}
            ],
            save_onsavecallback: upload_orginal

        };
        tinymce.init(opts);
    } else {
        setTimeout(arguments.callee, 50);
    }

}