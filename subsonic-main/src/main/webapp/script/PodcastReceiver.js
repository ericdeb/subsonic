
var MainController = (function() {

    var instance = null;

    var constructor = function() {

/* from podcastReceiver.jsp */
        var channelCount = ${fn:length(model.channels)};

        /* from podcastReceiver.jsp */
        function downloadSelected() {
            location.href = "podcastReceiverAdmin.view?downloadChannel=" + getSelectedChannels() +
                            "&downloadEpisode=" + getSelectedEpisodes() +
                            "&expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function deleteSelected() {
            if (confirm("<fmt:message key="podcastreceiver.confirmdelete"/>")) {
                location.href = "podcastReceiverAdmin.view?deleteChannel=" + getSelectedChannels() +
                "&deleteEpisode=" + getSelectedEpisodes() +
                "&expandedChannels=" + getExpandedChannels();
            }
        }

        /* from podcastReceiver.jsp */
        function refreshChannels() {
            location.href = "podcastReceiverAdmin.view?refresh=" +
                            "&expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function refreshPage() {
            location.href = "podcastReceiver.view?expandedChannels=" + getExpandedChannels();
        }

        /* from podcastReceiver.jsp */
        function toggleEpisodes(channelIndex) {
            for (var i = 0; i < episodeCount; i++) {
                var row = $("episodeRow" + i);
                if (row.title == "channel" + channelIndex) {
                    row.toggle();
                    $("channelExpanded" + channelIndex).checked = row.visible() ? "checked" : "";
                }
            }
        }

        /* from podcastReceiver.jsp */
        function toggleAllEpisodes(visible) {
            for (var i = 0; i < episodeCount; i++) {
                var row = $("episodeRow" + i);
                if (visible) {
                    row.show();
                } else {
                    row.hide();
                }
            }
            for (i = 0; i < channelCount; i++) {
                $("channelExpanded" + i).checked = visible ? "checked" : "";
            }
        }

        /* from podcastReceiver.jsp */
        function getExpandedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var checkbox = $("channelExpanded" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
            return result;
        }

        /* from podcastReceiver.jsp */
        function getSelectedChannels() {
            var result = "";
            for (var i = 0; i < channelCount; i++) {
                var checkbox = $("channel" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
            return result;
        }

        /* from podcastReceiver.jsp */
        function getSelectedEpisodes() {
            var result = "";
            for (var i = 0; i < episodeCount; i++) {
                var checkbox = $("episode" + i);
                if (checkbox.checked) {
                    result += (checkbox.value + " ");
                }
            }
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