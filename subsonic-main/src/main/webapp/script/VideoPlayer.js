
var VideoController = (function() {

    var instance = null;

    var constructor = function() {


        /* from videoPlayer.jsp */
        function videoPlayerInit() {

            var flashvars = {
                id:"player1",
                skin:"<c:url value="/flash/whotube.zip"/>",
                screencolor:"000000",
                controlbar:"over",
                autostart:"false",
                bufferlength:3,
                backcolor:"<spring:theme code="backgroundColor"/>",
                frontcolor:"<spring:theme code="textColor"/>",
                provider:"video"
            };
            var params = {
                allowfullscreen:"true",
                allowscriptaccess:"always"
            };
            var attributes = {
                id:"player1",
                name:"player1"
            };

            var width = "${model.popout ? '100%' : '600'}";
            var height = "${model.popout ? '85%' : '360'}";
            swfobject.embedSWF("<c:url value="/flash/jw-player-5.10.swf"/>", "placeholder1", width, height, "9.0.0", false, flashvars, params, attributes);
        }

        /* from videoPlayer.jsp */
        function playerReady(thePlayer) {
            player = $("player1");
            player.addModelListener("TIME", "timeListener");

            play();
        }

        /* from videoPlayer.jsp */
        function play() {
            var list = new Array();
            list[0] = {
                file:"${streamUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + timeOffset + "&player=${model.player}",
                duration:${model.duration} - timeOffset,
                provider:"video"
            };
            player.sendEvent("LOAD", list);
            player.sendEvent("PLAY");
        }

        /* from videoPlayer.jsp */
        function timeListener(obj) {
            var newPosition = Math.round(obj.position);
            if (newPosition != position) {
                position = newPosition;
                updatePosition();
            }
        }

        /* from videoPlayer.jsp */
        function updatePosition() {
            var pos = getPosition();

            var minutes = Math.round(pos / 60);
            var seconds = pos % 60;

            var result = minutes + ":";
            if (seconds < 10) {
                result += "0";
            }
            result += seconds;
            $("position").innerHTML = result;
        }

        /* from videoPlayer.jsp */
        function changeTimeOffset() {
            timeOffset = $("timeOffset").getValue();
            play();
        }

        /* from videoPlayer.jsp */
        function changeBitRate() {
            maxBitRate = $("maxBitRate").getValue();
            timeOffset = getPosition();
            play();
        }

        /* from videoPlayer.jsp */
        function popout() {
            var url = "${baseUrl}&maxBitRate=" + maxBitRate + "&timeOffset=" + getPosition() + "&popout=true";
            popupSize(url, "video", 600, 400);
            window.location.href = "${backUrl}";
        }

        /* from videoPlayer.jsp */
        function popin() {
            window.close();
        }

        /* from videoPlayer.jsp */
        function getPosition() {
            return parseInt(timeOffset) + parseInt(position);
        }


        /* from videoPlayer.jsp */
        var player;
        var position;
        var maxBitRate = ${model.maxBitRate};
        var timeOffset = ${model.timeOffset};

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