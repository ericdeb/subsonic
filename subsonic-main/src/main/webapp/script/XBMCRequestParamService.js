
var XBMCRequestParamService = function() {

    var createRequestParams = function(method, params, id) {
        var reqParams = {
            jsonrpc: "2.0",
            method: method,
            params: params
        };
        if (id) {
            reqParams.id = id;
        }
        return reqParams;
    };

    var getStopParams = function() {
        return createRequestParams("Player.Stop", {"playerid": 0}, 0);
    };

    var getOpenParams = function(filePath) {
        var XBMCParams = {
            item: {
                playlistid: 0,
                position: 1
            }
        };
        return createRequestParams("Player.Open", XBMCParams, 0);
    };

    var getGoToParams = function(position) {
        var XBMCParams = {
            playerid: 0,
            to: position
        };
        return createRequestParams("Player.GoTo", XBMCParams, 0);
    };

    var getPlayerPropertiesParams = function() {
        var XBMCParams = {
            playerid: 0,
            properties: ["position", "time"]
        };
        return createRequestParams("Player.GetProperties", XBMCParams, 0);
    };

    var getAddTrackParams = function(filePath) {
        var XBMCParams = {
            playlistid: 0,
            item: {
                file: filePath
            }
        };
        return createRequestParams("Playlist.Add", XBMCParams, 0);
    };

    var getQueueTrackParams = function(filePath, position) {
        var XBMCParams = {
            playlistid: 0,
            position: position,
            item: {
                file: filePath
            }
        };
        return createRequestParams("Playlist.Insert", XBMCParams, 0);
    };

    var getPlayPauseParams = function(play) {
        var XBMCParams = {
            playerid: 0,
            play: play
         };
        return createRequestParams("Player.PlayPause", XBMCParams, 0);
    };

    var getSwapTrackParams = function(position1, position2) {
        var XBMCParams = {
            playlistid: 0,
            position1: position1,
            position2: position2
        };
        return createRequestParams("Playlist.Swap", XBMCParams, 0);
    };

    var getRemoveTrackParams = function(position) {
        var XBMCParams = {
            playlistid: 0,
            position: position
        };
        return createRequestParams("Playlist.Remove", XBMCParams, 0);
    };

    var getClearParams = function() {
        var XBMCParams = {
            playlistid: 0
        };
        return createRequestParams("Playlist.Clear", XBMCParams, 0);
    };

    var getGetPlaylistParams = function() {
        var XBMCParams = {
            playlistid: 0,
            properties: ["file"]
        };
        return createRequestParams("Playlist.GetItems", XBMCParams, 1);
    };

    return {
        getStopParams: getStopParams,
        getOpenParams: getOpenParams,
        getGoToParams: getGoToParams,
        getClearParams: getClearParams,
        getAddTrackParams: getAddTrackParams,
        getQueueTrackParams: getQueueTrackParams,
        getPlayPauseParams: getPlayPauseParams,
        getPlayerPropertiesParams: getPlayerPropertiesParams,
        getSwapTrackParams: getSwapTrackParams,
        getRemoveTrackParams: getRemoveTrackParams,
        getGetPlaylistParams: getGetPlaylistParams
    };

};