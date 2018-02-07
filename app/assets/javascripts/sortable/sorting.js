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

    addSort = function () {
        var component_elements = document.getElementById(components_field_id),
            citation_elements = document.getElementById(citations_field_id),
            options = {
                animation: 250,
                ghostClass: 'ghost'
            };
        makeSortable(component_elements, options);
        makeSortable(citation_elements, options);
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