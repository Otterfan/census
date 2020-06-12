var el = document.querySelector('#select_sort_order');
if (el) {
    el.addEventListener("change", function () {
        var sort_val = document.querySelector('#select_sort_order').value,
            sort_param = 'sort=' + sort_val,
            new_search = '';

        var sort_input = document.querySelector('#sort');
        sort_input.value = sort_val;

        if (location.search.includes('sort=')) {
            new_search = location.search.replace(/sort=[^&$]*/i, sort_param);
        } else {
            new_search = location.search.concat('&', sort_param)
        }

        if (new_search.includes('page=')) {
            new_search = location.search.replace(/page=[^&$]*&?/i, '');
        }

        location.search = new_search
    });
}

