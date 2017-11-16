function showForTranslator(event) {
    console.log(event);
    var $select = $(event);
    console.log($select);
    var show_or_hide = $(event.parentNode).children('.translator-only');
    if ($select.val() === 'translator') {
        show_or_hide.show();
    }
    else {
        show_or_hide.hide();
    }
}