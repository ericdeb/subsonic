
var MainController = (function() {

    var instance = null;

    var constructor = function() {

        var url = 'top.view',
            domId = 'topMain';





        /* from related.jsp */
        function relatedInit() {
            $("#artistBio").children('a').attr("target", "_blank");
        }

        /* from genres.jsp */
        function genresInit() {
            $("#genreDesc a").attr("target", "_blank");
        }


        /* from missingAlbums.jsp */
        function search(page) {
            $('#albums').load('missingAlbumsSearch.view?page=' + page + '&' + $('form').serialize());
            window.scrollTo(0, 0);
        }

        /* from loadPlaylist.jsp */
        function deletePlaylist(deleteUrl) {
            if (confirm("<fmt:message key="playlist.load.confirm_delete"/>")) {
                location.href = deleteUrl;
            }
        }


        // Initialization Code
        handleUpdate();

        return {
            udpate: update
            //
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