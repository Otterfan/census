BCComments = (function () {
    function show_result(data) {
        var text = '<div class="the-text">' + data.comment.value + '</div>' +
            '<div class="comment-metadata">' +
            '<span class="the-user">' + data.email + '</span>' +
            '<span class="the-date">' + data.comment.created_at + '</span>' +
            '</div>';
        $('.text-comments').prepend('<li class="list-group-item comment">' + text + '</li>');
    }

    function add() {
        var commenter_id = $('#comment_user_id').val(),
            text_id = $('#comment_text_id').val(),
            auth_token = $('#comment_auth_token').val();

        var data = {
            "comment[value]": $('#comment_value').val(),
            "comment[user_id]": commenter_id,
            "comment[text_id]": text_id,
            "authenticity_token": auth_token
        };

        $.post('/comments', data, show_result);
    }

    return {
        fetch: fetch,
        add: add
    };
}());