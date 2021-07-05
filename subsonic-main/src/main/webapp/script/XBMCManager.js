
var XBMCManager = (function() {

    var instance = null;

    var constructor = function(xbmcSyncEnabled) {


     // Services
        var RequestHandler,
            ResponseHandler;

        var websocket,
            initialXBMCPlaylist = [],
            xbmcToSubsonicHash = [],  // XBMC songID -> File Path
            subsonicFilePathHash = [], // File Path -> Subsonic Id
            playingHidden = false; // XBMC can play tracks without being on the playlist


     // Private Methods
        var _convertStringsToInts = function(strings) {
            var ints = [];
            for (var i = 0; i < strings.length; i++) {
                ints.push(parseInt(strings[i], 10));
            }
            return ints;
        };

        var _processNewFilePaths = function(paths, callback) {
            paths = (paths instanceof Array) ? paths : [];
            if (paths.length > 0) {
                SubsonicPlaylistService.getInstance().getTrackIDsFromPaths(paths, function(trackString) {
                    var trackIds = _convertStringsToInts(trackString.split('""'));

                    if (trackIds.length !== paths.length) {
                        console.log("File path processing inconsistency");
                    }

                    for (var i = 0; i < trackIds.length; i++) {
                        subsonicFilePathHash[paths[i]] = trackIds[i];
                    }

                    callback();
                });
            } else {
                callback();
            }
        };


     // Public Methods
        var addNewXBMCSongs = function(songs, callback) {
            var filePath,
                _needSubsonicSongIds = [];

            songs = (songs instanceof Array) ? songs : [];

            for (var i = 0; i < songs.length; i++) {
                filePath = songs[i].filePath;
                if (!subsonicFilePathHash[filePath]) {
                    _needSubsonicSongIds.push(filePath);
                }
                xbmcToSubsonicHash[songs[i].id] = filePath;
            }
            _processNewFilePaths(_needSubsonicSongIds, callback);
        };

        var isXBMCSyncEnabled = function() {
            return xbmcSyncEnabled;
        };

        var getRequestHandler = function() {
            if (RequestHandler)
                return RequestHandler;
        };

        var getSubsonicSongId = function(XBMCSongId) {
            return subsonicFilePathHash[xbmcToSubsonicHash[XBMCSongId]];
        };

        var setInitialXBMCPlaylist = function(XBMCPlaylist) {
            initialXBMCPlaylist = (XBMCPlaylist instanceof Array) ? XBMCPlaylist : [];
        };

        var setPlayingHidden = function(playingHidden) {
            playingHidden = playingHidden || false;
        };

        if (xbmcSyncEnabled) {
            websocket = new WebSocket('ws://192.168.1.117:9090/jsonrpc');
        }

        if (websocket) {
            websocket.onopen = function(event) {
                RequestHandler = XBMCRequestHandler(websocket);
                ResponseHandler = XBMCResponseHandler(websocket);
            };
        }


        return {
            addNewXBMCSongs: addNewXBMCSongs,
            getRequestHandler: getRequestHandler,
            getSubsonicSongId: getSubsonicSongId,
            isXBMCSyncEnabled: isXBMCSyncEnabled,
            setInitialXBMCPlaylist: setInitialXBMCPlaylist,
            setPlayingHidden: setPlayingHidden,
        };
    };

    return {
        getInstance: function() {
            if (!instance)
                throw "XBMCManager not constructed yet";
            return instance;
        },
        constructor: function() {
            if (instance)
                throw "XBMCManager already constructed";
            instance = constructor.apply(null, arguments);
            return instance;
        }
    };

})();