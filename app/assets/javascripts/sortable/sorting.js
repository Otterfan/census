BCSorter = (function () {
    var sortable;

    const components_field_id = 'components';
    const citations_field_id = 'citations';


    function numberForm() {
        var component_divs = document.getElementById(components_field_id).children,
            citation_divs = document.getElementById(citations_field_id).children;

        assignOrdinals(component_divs, 0);
        assignOrdinals(citation_divs, 0);
        return false;
    }

    function assignOrdinals(sortable_elements, ordinal) {
        console.log('assigning');
        for (var i = 0; i < sortable_elements.length; i++) {
            if (isSortableNode(sortable_elements[i])) {
                console.log('is sortable');
                assignNumber(sortable_elements[i], ordinal);
                ordinal++;
            } else {
                console.log('nope');
                console.log(sortable_elements[i]);
            }
        }
    }

    function assignNumber(div, ordinal) {
        div.querySelector('.ordinal-num').value = ordinal;
    }

    function isSortableNode(node) {
        return node.classList.contains('sortable-item');
    }


    function makeSortable(to_sort, options) {
        if (to_sort !== null) {
            sortable = Sortable.create(to_sort, options);
        }
    }

    function makeCollapsedComponentTitle(ordinal, target)
    {
        var $target = $(target),
            collapse_display = $target.find('.collapsed-display'),
            collapsed_display_val,
            title = $target.find('[name*="title"]').val(),
            pages = $target.find('[name*="pages"]').val(),
            name = $target.find('[name*="name"]').val();
        if (name) {
            collapsed_display_val = name;
        } else {
            collapsed_display_val = title + " " + pages;
        }
        collapse_display.text(collapsed_display_val);
    }

    function collapseComponents(event) {
        var targets = $('.component-fields');
        $.each(targets, makeCollapsedComponentTitle);
        $('.component-fields .collapsed-display').show();
        $('#collapse-components span').toggle();
        $('#components .component-fields').addClass('collapsed-li');
        $('.component-collapsable').collapse('hide');
    }

    function openComponents(event) {
        $('.component-fields  .collapsed-display').hide();
        $('#collapse-components span').toggle();
        $('#components .component-fields').removeClass('collapsed-li');
        $('.component-collapsable').collapse('show');
    }

    function collapseCitations(event) {
        var targets = $('.citation-fields');
        $.each(targets, makeCollapsedComponentTitle);
        $('.citation-fields .collapsed-display').show();
        $('#collapse-citations span').toggle();
        $('#citations .citation-fields').addClass('collapsed-li');
        $('.citation-collapsable').collapse('hide');
    }

    function openCitations(event) {
        $('.citation-fields .collapsed-display').hide();
        $('#collapse-citations span').toggle();
        $('#citations .citation-fields').removeClass('collapsed-li');
        $('.citation-collapsable').collapse('show');
    }

    addSort = function () {
        var component_elements = document.getElementById(components_field_id),
            citation_elements = document.getElementById(citations_field_id),
            options = {
                animation: 150,
                ghostClass: 'ghost',
                filter: '.links'
            };
        makeSortable(component_elements, options);
        makeSortable(citation_elements, options);

        $('#collapse-components .collapse-command').click(collapseComponents);
        $('#collapse-components .open-command').click(openComponents);

        $('#collapse-citations .collapse-command').click(collapseCitations);
        $('#collapse-citations .open-command').click(openCitations);
    };

    sortBeforeSubmit = function () {
        var edit_forms = document.getElementsByClassName('edit_text');
        if (edit_forms.length > 0) {
            edit_forms[0].addEventListener('submit', numberForm, false);
        }
    };


    sorter = {
        addSort: addSort,
        sortBeforeSubmit: sortBeforeSubmit,
        numberForm: numberForm
    };

    return sorter;
})();