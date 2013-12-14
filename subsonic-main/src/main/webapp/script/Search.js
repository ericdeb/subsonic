
var MainController = (function() {

    var instance = null;

    var constructor = function() {

        /* from advancedSearch.jsp */
        function search(page) {
            $('#songs').load('advancedSearchResult.view?page=' + page + '&' + $('form').serialize());
            window.scrollTo(0, 0);
        }

        /* from advancedSearch.jsp */
        function addOption(id) {
            $('#addOptions').append($('<option></option>').attr('value', id).text(id.replace(/_/g, ' ')));
        }


        return {
        };
    };

    return {
        getInstance: function() {
            if (!instance)
                instance = constructor();
            return instance;
        }
    };

})();