
var XBMCPlaylistProxy = (function() {

    var instance = null;

    var constructor = function() {

        // Variables
        var initialPlaylistCall = true.
            firstQueueAdd = true;

        var GET_FILES_COMMANDS = {};
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.TRACKS] = 'getSongsString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.RANDOM] = 'getRandomSongsString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.ARTIST_RADIO] = 'getArtistRadioString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.TOP_TRACKS] = 'getTopTracksString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.GENRE_RADIO] = 'getGenreRadioString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.GROUP_RADIO] = 'getGroupRadioString';
        GET_FILES_COMMANDS[PLAYLIST_COMMANDS.PLAY.RELATED_ARTISTS_SAMPLER] = 'getRelatedArtistsSamplerString';

        // Private methods
        var _filePathsCallback = function(filePaths, mode) {

            var XBMCRequestHandler = XBMCManager.getInstance().getRequestHandler();

            var filePathsList = (filePaths === "") ? [] : filePaths.split('""');

            if (filePathsList.length === 0) {
                if (initialPlaylistCall) {
                    initialPlaylistCall = false;
                    XBMCRequestHandler.sendGetPlaylist();
                    XBMCRequestHandler.sendGetPlayerProperties();
                }
                return;
            }

            if (mode === PLAYLIST_MODES.PLAY) {
                XBMCRequestHandler.sendStartPlayTracks(filePathsList, false);
            } else {
                var method = (mode === PLAYLIST_MODES.ENQUEUE) ? 'sendQueueTracks' : 'sendAddTracks';
                XBMCRequestHandler[method](filePathsList, firstQueueAdd);
            }
            firstQueueAdd = false;
        };

        var _getFilePathsCallbackWrapper = function() {
            var callArguments = arguments;
            setTimeout(function() {
                _filePathsCallback.apply(this, callArguments);
            }, 0);
        };

        var _addGetFilePathsCallbackWrapperToParams = function(params, mode) {
            params.push(function(playlist) {
                playlistReady = false;
                _getFilePathsCallbackWrapper(playlist, mode);
            });
        };


        // Public Methods
        var proxyPlaylistCommand = function(method, args) {
            args = args || [];
            var index,
                playCommand = false;

            var XBMCRequestHandler = XBMCManager.getInstance().getRequestHandler();

            switch (method) {
                case PLAYLIST_COMMANDS.UP:
                    index = args[0];
                    XBMCRequestHandler.sendSwapTracks(index, index - 1);
                    return false;
                case PLAYLIST_COMMANDS.DOWN:
                    index = args[0];
                    XBMCRequestHandler.sendSwapTracks(index, index + 1);
                    return false;
                case PLAYLIST_COMMANDS.SKIP:
                    index = args[0];
                    XBMCRequestHandler.sendGoToPosition(index);
                    return true;
                case PLAYLIST_COMMANDS.REMOVE:
                    index = args[0];
                    XBMCRequestHandler.sendRemoveTracks([index]);
                    return true;
                case PLAYLIST_COMMANDS.PLAY.TRACKS:
                case PLAYLIST_COMMANDS.PLAY.RANDOM:
                case PLAYLIST_COMMANDS.PLAY.ARTIST_RADIO:
                case PLAYLIST_COMMANDS.PLAY.TOP_TRACKS:
                    playCommand = true;
                    break;
            }

            var getFilesMethod = GET_FILES_COMMANDS[method];

            if (playlistService[getFilesMethod]) {
                if (playCommand) {
                    _addGetFilePathsCallbackWrapperToParams(args, args[1]);
                } else {
                    args.push(_getFilePathsCallbackWrapper);
                }
                playlistService[getFilesMethod].apply(this, args);

                return true;
            }

            return false;
        };

        return {
            proxyPlaylistCommand: proxyPlaylistCommand
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