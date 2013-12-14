
var MainController = (function() {

    var instance = null;

    var constructor = function() {


        /* from rightInit.jsp */
        function rightInit() {
            setupZoom('<c:url value="/"/>');
            dwr.engine.setErrorHandler(null);
            <c:if test="${model.showChat}">
                chatService.addMessage(null);
            </c:if>
        }

        /* from right.jsp */
        startGetNowPlayingTimer();

        /* from right.jsp */
        function startGetNowPlayingTimer() {
            nowPlayingService.getNowPlaying(getNowPlayingCallback);
            setTimeout("startGetNowPlayingTimer()", 10000);
        }

        /* from right.jsp */
        function getNowPlayingCallback(nowPlaying) {
            var html = nowPlaying.length == 0 ? "" : "<h2><fmt:message key="main.nowplaying"/></h2><table>";
            for (var i = 0; i < nowPlaying.length; i++) {
                html += "<tr><td colspan='2' class='detail' style='padding-top:1em;white-space:nowrap'>";

                if (nowPlaying[i].avatarUrl != null) {
                    html += "<img src='" + nowPlaying[i].avatarUrl + "' style='padding-right:5pt'>";
                }
                html += "<b>" + nowPlaying[i].username + "</b></td></tr>"

                html += "<tr><td class='detail' style='padding-right:1em'>" +
                        "<a title='" + nowPlaying[i].tooltip + "' target='main' href='" + nowPlaying[i].albumUrl + "'><em>" +
                        nowPlaying[i].artist + "</em><br/>" + nowPlaying[i].title + "</a>";

                if (nowPlaying[i].lyricsUrl != null) {
                    html += "<br/><span class='forward'><a href='" + nowPlaying[i].lyricsUrl + "' onclick=\"return popupSize(this, 'lyrics', 500, 550)\">" +
                            "<fmt:message key="main.lyrics"/>" + "</a></span>";
                }
                html += "</td><td style='padding-top:1em'>";

                if (nowPlaying[i].coverArtUrl != null) {
                    html += "<a rel='zoom' href='" + nowPlaying[i].coverArtZoomUrl + "'>" +
                            "<img src='" + nowPlaying[i].coverArtUrl + "' width='64' height='64'></a>";
                }
                html += "</td></tr>";

                var minutesAgo = nowPlaying[i].minutesAgo;
                if (minutesAgo > 4) {
                    html += "<tr><td class='detail' colspan='2'>" + minutesAgo + " <fmt:message key="main.minutesago"/></td></tr>";
                }
            }
            html += "</table>";
            $('nowPlaying').innerHTML = html;
            prepZooms();
        }

        /* from right.jsp */
        var revision = 0;
        startGetMessagesTimer();

        /* from right.jsp */
        function startGetMessagesTimer() {
            chatService.getMessages(revision, getMessagesCallback);
            setTimeout("startGetMessagesTimer()", 10000);
        }

        /* from right.jsp */
        function addMessage() {
            chatService.addMessage($("message").value);
            dwr.util.setValue("message", null);
            setTimeout("startGetMessagesTimer()", 500);
        }

        /* from right.jsp */
        function clearMessages() {
            chatService.clearMessages();
            setTimeout("startGetMessagesTimer()", 500);
        }

        /* from right.jsp */
        function getMessagesCallback(messages) {

            if (messages == null) {
                return;
            }
            revision = messages.revision;

            // Delete all the rows except for the "pattern" row
            dwr.util.removeAllRows("chatlog", { filter:function(div) {
                return (div.id != "pattern");
            }});

            // Create a new set cloned from the pattern row
            for (var i = 0; i < messages.messages.length; i++) {
                var message = messages.messages[i];
                var id = i + 1;
                dwr.util.cloneNode("pattern", { idSuffix:id });
                dwr.util.setValue("user" + id, message.username);
                dwr.util.setValue("date" + id, " [" + formatDate(message.date) + "]");
                dwr.util.setValue("content" + id, message.content);
                $("pattern" + id).show();
            }

            var clearDiv = $("clearDiv");
            if (clearDiv) {
                if (messages.messages.length == 0) {
                    clearDiv.hide();
                } else {
                    clearDiv.show();
                }
            }
        }

        /* from right.jsp */
        function formatDate(date) {
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var result = hours < 10 ? "0" : "";
            result += hours;
            result += ":";
            if (minutes < 10) {
                result += "0";
            }
            result += minutes;
            return result;
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