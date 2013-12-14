
var MainController = (function() {

    var instance = null;

    var constructor = function() {

       /* from editTags.jsp */
        var index = 0;
        var fileCount = ${fn:length(model.songs)};

        /* from editTags.jsp */
        function setArtist() {
            var artist = dwr.util.getValue("artistAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("artist" + i, artist);
            }
        }

        /* from editTags.jsp */
        function setAlbumArtist() {
            var albumartist = dwr.util.getValue("albumArtistAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("albumArtist" + i, albumartist);
            }
        }

        /* from editTags.jsp */
        function setComposer() {
            var composer = dwr.util.getValue("composerAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("composer" + i, composer);
            }
        }

        /* from editTags.jsp */
        function setAlbum() {
            var album = dwr.util.getValue("albumAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("album" + i, album);
            }
        }

        /* from editTags.jsp */
        function setYear() {
            var year = dwr.util.getValue("yearAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("year" + i, year);
            }
        }

        /* from editTags.jsp */
        function setGenre() {
            var genre = dwr.util.getValue("genreAll");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("genre" + i, genre);
            }
        }

        /* from editTags.jsp */
        function suggestTitle() {
            for (i = 0; i < fileCount; i++) {
                var title = dwr.util.getValue("suggestedTitle" + i);
                dwr.util.setValue("title" + i, title);
            }
        }

        /* from editTags.jsp */
        function resetTitle() {
            for (i = 0; i < fileCount; i++) {
                var title = dwr.util.getValue("originalTitle" + i);
                dwr.util.setValue("title" + i, title);
            }
        }

        /* from editTags.jsp */
        function suggestTrack() {
            for (i = 0; i < fileCount; i++) {
                var track = dwr.util.getValue("suggestedTrack" + i);
                dwr.util.setValue("track" + i, track);
            }
        }

        /* from editTags.jsp */
        function resetTrack() {
            for (i = 0; i < fileCount; i++) {
                var track = dwr.util.getValue("originalTrack" + i);
                dwr.util.setValue("track" + i, track);
            }
        }

        /* from editTags.jsp */
        function updateTags() {
            document.getElementById("save").disabled = true;
            index = 0;
            dwr.util.setValue("errors", "");
            for (i = 0; i < fileCount; i++) {
                dwr.util.setValue("status" + i, "");
            }
            updateNextTag();
        }

        /* from editTags.jsp */
        function updateNextTag() {
            var id = dwr.util.getValue("id" + index);
            var artist = dwr.util.getValue("artist" + index);
            var albumartist = dwr.util.getValue("albumArtist" + index);
            var composer = dwr.util.getValue("composer" + index);
            var track = dwr.util.getValue("track" + index);
            var album = dwr.util.getValue("album" + index);
            var title = dwr.util.getValue("title" + index);
            var year = dwr.util.getValue("year" + index);
            var genre = dwr.util.getValue("genre" + index);
            dwr.util.setValue("status" + index, "<fmt:message key="edittags.working"/>");
            tagService.setTags(id, track, artist, albumartist, composer, album, title, year, genre, setTagsCallback);
        }

        /* from editTags.jsp */
        function setTagsCallback(result) {
            var message;
            if (result == "SKIPPED") {
                message = "<fmt:message key="edittags.skipped"/>";
            } else if (result == "UPDATED") {
                message = "<b><fmt:message key="edittags.updated"/></b>";
            } else {
                message = "<div class='warning'><fmt:message key="edittags.error"/></div>"
                var errors = dwr.util.getValue("errors");
                errors += result + "<br/>";
                dwr.util.setValue("errors", errors, { escapeHtml:false });
            }
            dwr.util.setValue("status" + index, message, { escapeHtml:false });
            index++;
            if (index < fileCount) {
                updateNextTag();
            } else {
                document.getElementById("save").disabled = false;
            }
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