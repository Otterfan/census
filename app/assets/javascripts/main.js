$(document).on('turbolinks:load', ready);

function ready() {
    BCPinner.pin();
    BCSorter.addSort();
    BCSorter.sortBeforeSubmit();



    const comment_form = $('#new-comment-form');
    comment_form.submit(function (event) {
        event.preventDefault();
        BCComments.add();
        return false;
    });

    $('#collapse-original-button').click(function () {
        $('#collapse-original-button span').toggleClass('glyphicon-collapse-down glyphicon-collapse-up');
    });


    function upload_original() {
        const pathArray = window.location.pathname.split('/');
        const original_text = tinymce.activeEditor.getContent(),
            post_address = '/texts/' + pathArray[2] + '/original';
        $.post(post_address, {original: original_text}, function (data) {
            console.log('success!!');
        });
    }

    if (typeof tinyMCE != 'undefined') {
        const content_style = '.small-text {font-size: small}';

        const opts = {
            selector: '.original-box textarea',
            menubar: false,
            plugins: 'save paste',
            paste_retain_style_properties: 'all',
            paste_word_valid_elements: 'b,strong,i,em,h1,h2,u,p,ol,ul,li,a[href],span,color,font-size,font-color,font-family,mark,pre,code',
            toolbar: 'bold italic formats styleselect | removeformat | paste | save',
            convert_urls : false,

            //template_external_list_url : "gen4tinymce/lists/template_list.js",
            external_link_list_url : "gen4tinymce/lists/link_list.js",
            //media_external_list_url : "gen4tinymce/lists/media_list.js",

            valid_elements : "@[id|class|style|title|dir<ltr?rtl|lang|xml::lang],"
            + "a[rel|rev|charset|hreflang|tabindex|accesskey|type|"
            + "name|href|target|title|class],strong/b,em/i,strike,u,"
            + "#p[style],-ol[type|compact],-ul[type|compact],-li,br,img[longdesc|usemap|"
            + "src|border|alt=|title|hspace|vspace|width|height|align],-sub,-sup,"
            + "-blockquote,-table[border=0|cellspacing|cellpadding|width|frame|rules|"
            + "height|align|summary|bgcolor|background|bordercolor],-tr[rowspan|width|"
            + "height|align|valign|bgcolor|background|bordercolor],tbody,thead,tfoot,"
            + "#td[colspan|rowspan|width|height|align|valign|bgcolor|background|bordercolor"
            + "|scope],#th[colspan|rowspan|width|height|align|valign|scope],caption,-div,"
            + "-span,-code,-pre,address,-h1,-h2,-h3,-h4,-h5,-h6,hr[size|noshade],-font[face"
            + "|size|color],dd,dl,dt,cite,abbr,acronym,del[datetime|cite],ins[datetime|cite],"
            + "object[classid|width|height|codebase|*],param[name|value|_value],embed[type|width"
            + "|height|src|*],map[name],area[shape|coords|href|alt|target],bdo,"
            + "button,col[align|char|charoff|span|valign|width],colgroup[align|char|charoff|span|"
            + "valign|width],dfn,fieldset,form[action|accept|accept-charset|enctype|method],"
            + "input[accept|alt|checked|disabled|maxlength|name|readonly|size|src|type|value],"
            + "kbd,label[for],legend,noscript,optgroup[label|disabled],option[disabled|label|selected|value],"
            + "q[cite],samp,select[disabled|multiple|name|size],small,"
            + "textarea[cols|rows|disabled|name|readonly],tt,var,big",
            extended_valid_elements : "p[style]",
            inline_styles : true,
            verify_html : false,
            save_onsavecallback: upload_original,
            style_formats: [
                {title: 'Small', inline: 'span', classes: 'small-text'},
                {title: 'Superscript', inline: 'sup'}
            ],
            content_style: content_style
        };
        tinymce.init(opts);
    } else {
        setTimeout(arguments.callee, 50);
    }

}