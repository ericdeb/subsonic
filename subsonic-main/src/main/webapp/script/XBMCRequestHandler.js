
var XBMCRequestHandler = function(websocket) {

 // Services
    var Params = XBMCRequestParamService();
    var frameLimit = 400;
    var requestQueueDelay = 100;
    var requestQueue = [];
    var queueRunning = false;

    var _startRequestQueue = function() {
        if (queueRunning || requestQueue.length === 0) {
            return;
        }
        queueRunning = true;
        websocket.send(requestQueue.shift());

        setTimeout(function() {
            queueRunning = false;
            _startRequestQueue();
        }, requestQueueDelay);
    };

    var _stringifyRequestParams = function(requestParams) {
        var len = requestParams.length,
            requests = [],
            command = '[',
            current;

        for (var i = 0; i < len; i++) {
            current = JSON.stringify(requestParams[i]);
            if (requestParams[i].method === "Playlist.GetItems" ||
                requestParams[i].method === "Player.GetProperties") {
                current = current.replace(/\\/g,'').replace(/\"\[/g,'[').replace(/\]\"/g,']');
            }

            if (command.length + current.length < frameLimit) {
                command += (i !== 0 ? ',' : '') + current;
            } else {
                requests.push(command + ']');
                command = '[' + current;
            }
        }

        requests.push(command + ']');

        return requests;
    };

 // Private Methods
    var _makeXBMCRequest = function(requestParams) {
        if (!(requestParams instanceof Array)) {
            requestParams = [requestParams];
        }

        var requests = _stringifyRequestParams(requestParams);
        requestQueue.push.apply(requestQueue, requests);
        _startRequestQueue();
    };

    var _addTracksToMultiRequest = function(multiRequest, filePaths, start) {
        for (var i = start; i < filePaths.length; i++) {
            multiRequest.push(Params.getAddTrackParams(filePaths[i]));
        }
        return multiRequest;
    };


 // Public Methods
    var sendStartPlayTracks = function(filePaths, startPaused) {
        var multiRequest = [];
        multiRequest.push(Params.getClearParams());
        multiRequest.push(Params.getAddTrackParams(filePaths[0]));
        multiRequest.push(Params.getOpenParams(filePaths[0]));

        if (startPaused)
            multiRequest.push(Params.getPlayPauseParams(false));

        _makeXBMCRequest(_addTracksToMultiRequest(multiRequest, filePaths, 1));
    };

    var sendPlayTrackAtPosition = function(position) {
        _makeXBMCRequest(Params.getGoToParams(position));
    };

    var sendAddTracks = function(filePaths, first) {
        if (first) {
            sendStartPlayTracks(filePaths, first);
            return;
        }
        _makeXBMCRequest(_addTracksToMultiRequest([], filePaths, 0));
    };

    var sendSwapTracks = function(position1, position2) {
        _makeXBMCRequest(Params.getSwapTrackParams(position1, position2));
    };

    var sendQueueTracks = function(filePaths, first) {
        if (first) {
            sendStartPlayTracks(filePaths, true);
            return;
        }

        var multiRequest = [];
        for (var i = 0; i < filePaths.length; i++) {
            multiRequest.push(Params.getQueueTrackParams(filePaths[i], i+1));
        }

        _makeXBMCRequest(multiRequest);
    };

    var sendRemoveTracks = function(positions) {
        positions = positions.sort(function(a, b) {
            return a - b;
        });

        var multiRequest = [];
        for (var i = 0; i < positions.length; i++) {
            multiRequest.push(Params.getRemoveTrackParams(positions[i] - i));
        }

        _makeXBMCRequest(multiRequest);
    };

    var sendGetPlayerProperties = function() {
        _makeXBMCRequest(Params.getPlayerPropertiesParams());
    };

    var sendGoToPosition = function(position) {
        _makeXBMCRequest(Params.getGoToParams(position));
    };

    var sendGetPlaylist = function() {
        console.log('Send getPlaylist');
        _makeXBMCRequest(Params.getGetPlaylistParams());
    };

    return {
        sendStartPlayTracks: sendStartPlayTracks,
        sendPlayTrackAtPosition: sendPlayTrackAtPosition,
        sendAddTracks: sendAddTracks,
        sendQueueTracks: sendQueueTracks,
        sendSwapTracks: sendSwapTracks,
        sendRemoveTracks: sendRemoveTracks,
        sendGetPlaylist: sendGetPlaylist,
        sendGetPlayerProperties: sendGetPlayerProperties,
        sendGoToPosition: sendGoToPosition
    };
};
