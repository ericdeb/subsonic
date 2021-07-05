var SubsonicWebPlayer = (function() {

    var instance = null;

    var constructor = function(backgroundColor, textColor, flashSrc) {


      /* from externalPlayer.jsp */
      function initExternalPlayer() {
          var flashvars = {
              id:"player1",
              screencolor:"000000",
              frontcolor:"<spring:theme code="textColor"/>",
              backcolor:"<spring:theme code="backgroundColor"/>",
              stretching: "fill",
              "playlist.position": "bottom",
              "playlist.size": 200
          };
          var params = {
              allowfullscreen:"true",
              allowscriptaccess:"always"
          };
          var attributes = {
              id:"player1",
              name:"player1"
          };
          swfobject.embedSWF("<c:url value="/flash/jw-player-5.10.swf"/>", "placeholder", "500", "500", "9.0.0", false, flashvars, params, attributes);
      }

      var jwPlayerSettings = {
           width: 340,
           height: 24,
           id: 'player1',
           backcolor: backgroundColor,
           frontcolor: textColor,
           dock: false,
           'controlbar.position': 'bottom',
           'modes': [
                {type: 'flash', src: flashSrc},
                {type: 'html5'},
                {type: 'download'}
            ]
        };


        // Private Methods
        var _createPlayer = function() {
          jwplayer('mediaplayer').setup(jwPlayerSettings);
          jwplayer('mediaplayer').onReady(
            function(event) {
              setTimeout(function() {
                PlaylistController.getInstance().sendPlaylistCommand(PLAYLIST_COMMANDS.GET_PLAYLIST);
              }, 0);
            }
          );
          jwplayer('mediaplayer').onComplete(
            function() {
              setTimeout(function() {
                PlaylistController.getInstance().sendPlaylistCommand(PLAYLIST_COMMANDS.NEXT);
              }, 0);
            }

          );
        };


        // Public Methods
        var loadList = function(list) {
          jwplayer('mediaplayer').load(list);
        };

        var play = function() {
          jwplayer('mediaplayer').play(true);
        };

        var stop = function() {
          jwplayer('mediaplayer').stop();
        };



        // Initialization Code
        _createPlayer();

        return {
            loadList: loadList,
            play: play,
            stop: stop
        };

    };

    return {
        getInstance: function() {
            if (!instance)
                throw "SubsonicWebPlayer not constructed yet";
            return instance;
        },
        constructor: function() {
            if (instance)
                throw "SubsonicWebPlayer already constructed";
            instance = constructor.apply(null, arguments);
            return instance;
        }
    };

})();