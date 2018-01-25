BCSorter = (function () {
    var sortable;

    const components_field_id = 'components';


    function numberForm() {
        var ordinal = 0;
        var component_divs = document.getElementById('components').children;

        for (var i = 0; i < component_divs.length; i++) {
            if (isSortableNode(component_divs[i])) {
                assignNumber(component_divs[i], ordinal);
                ordinal++;
            }
        }
        return false;
    }


    function assignNumber(div, ordinal) {
        div.querySelector('.ordinal-num').value = ordinal;
    }

    function isSortableNode(node) {
        return node.classList.contains('sortable-item');
    }


    addSort = function () {
        var el, options;

        options = {
            handle: '.handle',
            filter: '.non-sorting'
        };

        el = document.getElementById(components_field_id);
        if (el !== null) {
            sortable = Sortable.create(el, options);
        }
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