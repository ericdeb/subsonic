
var XBMCResponseHandler = function(websocket) {

    var newMsg = {
        queue: [],
        delay: 100,
        timeout: null
    };


    var firstPlaylistMsg = true,
        firstPlayerMsg = true,
        playlistMsgSent = false,
        addCommands,
        removeCommands = [];

    var MESSAGES = {
        PLAYER: {
            ON_PLAY: 'Player.OnPlay',
            ON_STOP: 'Player.OnStop',
            ON_PAUSE: 'Player.OnPause'
        },
        PLAYLIST: {
            ON_CLEAR: 'Playlist.OnClear',
            ON_ADD: 'Playlist.OnAdd',
            ON_REMOVE: 'Playlist.OnRemove'
        }
    };

    var _resetAddCommands = function() {
        addCommands = {
            subsonicIds: [],
            startPos: null,
            lastPos: null
        };
    };

    var _searchNewMsgQueueMethods = function(methods) {
        var item;
        for (var i = 1; i < newMsg.queue.length; i++) {
            for (var j = 0; j < methods.length; j++) {
                if (newMsg.queue[i].method === methods[j]) {
                    return true;
                }
            }
        }
        return false;
    };

    var _sendGetPlaylistMsg = function() {
        if (!playlistMsgSent) {
            playlistMsgSent = true;
            XBMCManager.getInstance().getRequestHandler().sendGetPlaylist();
        }
    };

    var _canSkipNewMsg = function(msg) {
        // can this message be skipped?
        switch (msg.method) {
            case MESSAGES.PLAYLIST.ON_ADD:
            case MESSAGES.PLAYLIST.ON_REMOVE:
            case MESSAGES.PLAYLIST.ON_CLEAR:
                if (_searchNewMsgQueueMethods([MESSAGES.PLAYLIST.ON_CLEAR])) {
                    console.log('skip 1');
                    return true;
                }
                break;
            case MESSAGES.PLAYER.ON_PLAY:
            case MESSAGES.PLAYER.ON_STOP:
            case MESSAGES.PLAYER.ON_PAUSE:
                var playbackMessages = [ MESSAGES.PLAYER.ON_PLAY,
                                         MESSAGES.PLAYER.ON_STOP ];
                if (_searchNewMsgQueueMethods(playbackMessages)) {
                    console.log('skip 2');
                    return true;
                }
                break;
        }

        return false;
    };

    var _processNewMessage = function(msg) {
        var id, pos, subsonicSongId, curPlaylistPos;

        try { id = msg.params.data.item.id; } catch (e) {}
        try { pos = msg.params.data.position; } catch (e) {}

        subsonicSongId = XBMCManager.getInstance().getSubsonicSongId(id);
        curPlaylistPos = PlaylistController.getInstance().getPlaylistPosForSongId(subsonicSongId);

        // is more info needed before processing?
        if (id && isNaN(subsonicSongId)) {
            _sendGetPlaylistMsg();
            return false;
        }

        // try to process
        switch (msg.method) {
            case MESSAGES.PLAYLIST.ON_ADD:
                addCommands.subsonicIds.push(subsonicSongId);
                addCommands.startPos = addCommands.startPos || pos;
                addCommands.lastPos = addCommands.lastPos || pos-1;
                var nextMsgAdd = newMsg.queue[1] && (newMsg.queue[1].method === MESSAGES.PLAYLIST.ON_ADD);

                if (!nextMsgAdd || (addCommands.lastPos !== pos - 1)) {
                    PlaylistController.getInstance().sendPlaylistCommand(PLAYLIST_COMMANDS.INSERT, 
                        addCommands.subsonicIds, addCommands.startPos);
                    _resetAddCommands();
                    break;
                }

                addCommands.lastPos = pos;
                break;
            case MESSAGES.PLAYLIST.ON_REMOVE:
                PlaylistController.getInstance().sendUnproxiedPlaylistCommand(PLAYLIST_COMMANDS.REMOVE, pos);
                break;
            case MESSAGES.PLAYLIST.ON_CLEAR:
                PlaylistController.getInstance().sendUnproxiedPlaylistCommand(PLAYLIST_COMMANDS.CLEAR);
                break;
            case MESSAGES.PLAYER.ON_PLAY:
                if (curPlaylistPos < 0) return false;
                PlaylistController.getInstance().sendUnproxiedPlaylistCommand(PLAYLIST_COMMANDS.SKIP, curPlaylistPos);
                // if (curPlaylistPos < 0) {
                //     XBMCManager.getInstance().setPlayingHidden(true);
                //     onPlayXBMC([subsonicId]);
                // } else {
                //     XBMCManager.getInstance().setPlayingHidden(false);
                //     skip(curPlaylistPos, true);
                // }
                break;
            case MESSAGES.PLAYER.ON_STOP:
                if (curPlaylistPos < 0) return false;
                PlaylistController.getInstance().sendUnproxiedPlaylistCommand(PLAYLIST_COMMANDS.STOP);
                break;
            case MESSAGES.PLAYER.ON_PAUSE:
                if (curPlaylistPos < 0) return false;
                PlaylistController.getInstance().sendUnproxiedPlaylistCommand(PLAYLIST_COMMANDS.PAUSE);
                console.log('pause command');
                break;
        }

        return true;
    };


    // processes a RESPONSE message (a request from subsonic for information)
    var _processResponseMessage = function(msg) {
        var newXBMCSongs = [],
            msgItems = [];

        try {
            msgItems = msg[0].result.items;
            msgItems = (msgItems instanceof Array) ? msgItems : [];
        } catch (e) {}

        for (var i = 0; i < msgItems.length; i++) {
            if (msgItems[i].type === "song" && msgItems[i].id && msgItems[i].file) {
                newXBMCSongs.push({
                    id: msgItems[i].id,
                    filePath: msgItems[i].file
                });

            }
        }

        if (newXBMCSongs.length > 0) {
            XBMCManager.getInstance().addNewXBMCSongs(newXBMCSongs, function() {
                if (firstPlaylistMsg) {
                    firstPlaylistMsg = false;
                    XBMCManager.getInstance().setInitialXBMCPlaylist(newXBMCSongs);
                }
                playlistMsgSent = false;
            });
        }
    };

    var _runNewMsgsQueue = function() {
        if (newMsg.queue.length > 0) {
            if (_canSkipNewMsg(newMsg.queue[0]) || _processNewMessage(newMsg.queue[0])) {
                newMsg.queue.shift();
                _runNewMsgsQueue();
            } else {
                clearTimeout(newMsg.timeout);
                newMsg.timeout = setTimeout(_runNewMsgsQueue, newMsg.delay);
            }
        }
    };

    _resetAddCommands();

    websocket.onmessage = function(event) {
        var data = event && event.data ? JSON.parse(event.data) : null;
        if (data) {
            if (!data.method) {
                // a response to our request for info
                _processResponseMessage(data);
            } else {
                // new XBMC command
                newMsg.queue.push(data);
                _runNewMsgsQueue();
            }
        }

    };

};
