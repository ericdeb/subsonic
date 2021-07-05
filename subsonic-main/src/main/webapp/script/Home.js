
var MainController = (function() {

    var instance = null;

    var constructor = function() {

        /* from home.jsp */
        function homeInit() {
            dwr.engine.setErrorHandler(null);
            $(".artistGenre").each(function() {
                var res = toCamelCase($(this).text())
                $(this).text(res);
            });

            $("#topLinks a").each(function() {
                if ($(this).text() === 'Starred') {
                    $(this).css('display', 'none');
                    $(this).next().css('display', 'none');
                }
            })
        }

        /* from home.jsp */
        function toCamelCase(str){
            return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
        };

        /* from home.jsp */
        function selectAll(b) {
            $(".songIndex").attr('checked', b);
        }

        /* from home.jsp */
        function getSelected() {
            var selectedSongs = [];
            $(".songIndex").each(function() {
                if ($(this).prop('checked')) {
                    selectedSongs.push($(this).next().val());
                }

            })
            return selectedSongs;
        }

        /* from home.jsp */
        function downloadSelected() {
            location.href = "download.view?id=" + unescape(encodeURIComponent(getSelected()));
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