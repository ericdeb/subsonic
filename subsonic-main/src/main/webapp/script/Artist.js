
var MainController = (function() {

    var instance = null;

    var constructor = function() {

        /* from artist.jsp */
        function noop() {}

        /* from artist.jsp */
        function artistInit() {
            dwr.engine.setErrorHandler(null);

            var trackIds = ${model.trackIds};
            var artistId = ${model.artistId};

            $("#selectPlayBut").click(function() {
                var playEnqAdd = $("#playEnqAdd option:selected");
                playMode = (playEnqAdd.text() === 'Add Last') ? 'Add' : playEnqAdd.text();
                var toPlay = $("#playEnqAddOptions option:selected").text();

                switch(toPlay) {
                    case 'All':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, trackIds, playEnqAdd.val());
                        break;
                    case 'Top Tracks':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TOP_TRACKS, artistId, playEnqAdd.val());
                        break;
                    case 'Artist Radio':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.ARTIST_RADIO, artistId, playEnqAdd.val());
                        break;
                    case 'Random':
                        top.playlist.sendPlaylistCommand(P_CMDS.PLAY.RANDOM, trackIds, playEnqAdd.val());
                        break;
                }
            });

            $("#bio0").children('a').attr("target", "_blank");
        }

        /* from artist.jsp */
        function playMode() {
            return $('#togglePlayAdd').attr('class').substring(0, 1);
        }

        /* from artist.jsp */
        function togglePlayAdd() {
            var t = $('#togglePlayAdd');
            if (t.attr('class') == 'Play') {
                t.attr('class', 'Enqueue');
            } else if (t.attr('class') == 'Enqueue') {
                t.attr('class', 'Add');
            } else {
                t.attr('class', 'Play');
            }
            var ids = ['all','top_tracks','artist_radio','random'];
            for (var i=0; i<ids.length; i++) {
                if ($('#'+ids[i])) {
                    $('#'+ids[i]).html(t.attr('class') + ' ' + ids[i].replace(/_/g, ' '));
                }
            }
        }

        /* from artist.jsp */
        function toggleArtist() {
            $('#bioArt').attr('width', 126 + 63 - $('#bioArt').attr('width'));
            $('#bioArt').attr('height', 126 + 63 - $('#bioArt').attr('height'));

            $('#bio0').toggle();
            $('#bio1').toggle();
        }

        /* from artistGenres.jsp */
        function add(name, count) {
            $("#inp").append('<div style="display: block">\
                <img class="dec" src="<spring:theme code="removeImage"/>" alt="Decrease" style="float: left; padding-top: 4px">\
                <div class="popularity" style="float: left"><div class="bar bgcolor3" style="width: ' + count + '%"></div><div class="genre">' + name + '</div></div>\
                <img class="inc" src="<spring:theme code="plusImage"/>" alt="Increase" style="float: left; padding-top: 4px">\
                <div style="clear:both;"></div></div>');

            $(".dec:last").click(function() {
                set_width($(this), -25);
            });

            $(".inc:last").click(function() {
                set_width($(this), 25);
            });

        }

        /* from artistGenres.jsp */
        function set_width(element, diff) {
            var bar = element.parent().find(".bar");
            var width = bar.width();
            var genre = element.parent().find(".genre").text();
            width = width + diff;
            if (width > 500) { width = 500 };
            if (width <=  0) {
                element.parent().remove();
                $("#genres").append("<option>" + genre + "</option>");
            } else {
                bar.width(width);
            }
            uiTagService.tagArtist(${model.artistId}, "${model.artistName}", genre, width / 5, diff > 0);
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