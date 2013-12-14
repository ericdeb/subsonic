
var SubsonicPlaylistService = (function() {

    var instance = null;

    var constructor = function() {

        var _playlistCallbackWrapper = function() {
            var callArguments = arguments;
            setTimeout(function() {
                PlaylistController.getInstance().updatePlaylist.apply(this, callArguments);
            }, 0);
        };

        var _addPlaylistCallbackWrapperToParams = function(params, mode) {
            params.push(function(playlist) {
                _playlistCallbackWrapper(playlist, mode);
            });
        };

        var sendSubsonicPlaylistCommand = function(method, args) {
            args = args || [];

            switch (method) {
                case PLAYLIST_COMMANDS.INSERT:
                    playlistService.insertFiles(args[0], 'I', args[1], _playlistCallbackWrapper);
                    break;
                case PLAYLIST_COMMANDS.PLAY.TRACKS:
                case PLAYLIST_COMMANDS.PLAY.RANDOM:
                case PLAYLIST_COMMANDS.PLAY.ARTIST_RADIO:
                case PLAYLIST_COMMANDS.PLAY.TOP_TRACKS:
                    _addPlaylistCallbackWrapperToParams(args, args[1]);
                    playlistService[method].apply(this, args);
                    break;
                default:
                    if (playlistService[method]) {
                        args.push(_playlistCallbackWrapper);
                        playlistService[method].apply(this, args);
                    }
                    break;
            }

        };

        var getTrackIDsFromPaths = function(paths, callback) {
            var _tracksReceived = function(tracks) {
                callback(tracks);
            };
            playlistService.getTrackIdsFromPaths(paths, _tracksReceived);
        };

        return {
            sendSubsonicPlaylistCommand: sendSubsonicPlaylistCommand,
            getTrackIDsFromPaths: getTrackIDsFromPaths
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