
var MainController = (function() {

    var instance = null;

    var constructor = function() {

        /* from radio.jsp */
        function radioInit() {
            $(".radioBut").click(function() {
                var rem = 'on', add = 'off';
                if ($(this).hasClass("off")) {
                    rem = 'off', add='on';
                }
                $(this).removeClass(rem).addClass(add);
            })
        }

        /* from radio.jsp */
        function playGenreRadio() {
            var genres = new Array();
            $('span.on').each(function() {
                genres.push($(this).text());
            });
            top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.GENRE_RADIO, genres);
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