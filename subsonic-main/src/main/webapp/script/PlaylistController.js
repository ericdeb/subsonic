
var PlaylistController = Singleton(function() {

    var instance = null;

    var constructor = function(webPlayer, partyMode, sliderEnabled) {

        // Private Variables
        var currentPlaylist = [],
            oldPlaylist = [],
            currentIndex = 0,
            currentStreamUrl = null,
            wrap = true,
            currentArtistId = null,
            currentAlbumId = null,
            currentStreamUrl = null,
            repeatEnabled = false,
            gain = 0,
            firstQueueAdd = true,
            initialPlaylistCall = true,
            playlistReady = false,
            stopped = true;

        // var _nowPlayingTimer = function() {
        //     nowPlayingService.getNowPlayingForCurrentPlayer(_nowPlayingCallback);
        //     setTimeout(_nowPlayingTimer, 10000);
        // }

        // var _nowPlayingCallback = function(nowPlayingInfo) {
        //     if (nowPlayingInfo != null && nowPlayingInfo.streamUrl != currentStreamUrl) {
        //         getPlaylist();
        //         if (currentArtistId != nowPlayingInfo.artistId && currentAlbumId != nowPlayingInfo.albumId && top.main.updateNowPlaying) {
        //             top.main.location.replace("nowPlaying.view?");
        //             currentArtistId = nowPlayingInfo.artistId;
        //             currentAlbumId = nowPlayingInfo.albumId;
        //         }
        //     <c:if test="${not model.player.web}">
        //         currentStreamUrl = nowPlayingInfo.streamUrl;
        //         updateCurrentImage();
        //     </c:if>
        //     }
        // }

        var _getIndexOfCurrentStreamUrl = function() {
            for (var i = 0; i < currentPlaylist.length; i++) {
                if (currentPlaylist[i].streamUrl === currentStreamUrl)
                    return i;
            }
            return -1;
        };

        var _updateCurrentImage = function() {
            for (var i = 0; i < currentPlaylist.length; i++) {
                var song  = currentPlaylist[i];
                var image = $("#currentImage" + i + 1);

                if (image) {
                    if (song.streamUrl === currentStreamUrl) {
                        image.show();
                    } else {
                        image.hide();
                    }
                }
            }
        };

        var _isPlayCommand = function(command) {
            for (var key in PLAYLIST_COMMANDS.PLAY) {
                if (PLAYLIST_COMMANDS.PLAY[key] === command)
                    return true;
            }
            return false;
        };

        var _requiresClearConfirmation = function(method, args) {
            if (method === PLAYLIST_COMMANDS.CLEAR)
                return true;

            if (_isPlayCommand(method) && args[1] === 'P')
                return true;

            return false;
        };

        var _onNextCommand = function() {
            var index = currentIndex + 1;
            if (wrap) {
                index = index % currentPlaylist.length;
            }
            skip(index);
        };

        var _onPreviousCommand = function() {
            var index = currentIndex - 1;
            if (index < 0) {
               index = wrap ? currentPlaylist.length - 1 : 0;
            }
            skip(index);
        };

        var _skip = function(index) {
            if (isNaN(index) || index < 0 || index >= currentPlaylist.length) {
                return;
            }

            var song = currentPlaylist[index];
            currentIndex = index;
            currentStreamUrl = song.streamUrl;

            PlaylistView.getInstance().updateCurrentPlayingImage(_getIndexOfCurrentStreamUrl());

            var list = [{
                file: song.streamUrl,
                title: song.title,
                provider: "sound"
            }];

            if (song.duration !== null) {
                list[0].duration = song.duration;
            }

            if (song.format == "aac" || song.format == "m4a") {
                list[0].provider = "video";
            }

            if (webPlayer) {
                SubsonicWebPlayer.getInstance().loadList(list);
                SubsonicWebPlayer.getInstance().play(list);
            }

        };

        var _sendPlaylistCommand = function(method, args, bypassProxy) {
            args = args || [];

            if (partyMode && (!_requiresClearConfirmation(method, args) || PlaylistView.getInstance().displayClearConfirm())) {
                return;
            }

            // try to proxy command and send to XBMC
            if (!bypassProxy && XBMCManager.getInstance().isXBMCSyncEnabled()) {
                if (XBMCPlaylistProxy.getInstance().proxyPlaylistCommand(method, args))
                    return;
            }

            switch (method) {
                case PLAYLIST_COMMANDS.NEXT:
                    _onNextCommand();
                    return;
                case PLAYLIST_COMMANDS.PREVIOUS:
                    _onPreviousCommand();
                    return;
                case PLAYLIST_COMMANDS.SKIP:
                    var index = args[0];
                    if (webPlayer) {
                        _skip(index);
                        return;
                    } else {
                        currentStreamUrl = currentPlaylist[index].streamUrl;
                    }
                    break;
            }

            SubsonicPlaylistService.getInstance().sendSubsonicPlaylistCommand(method, args);
        };




        // Public Methods
        var load = function() {

            var fullUrl = _buildUrl(),
                result = Ajax.getInstance().updateDomFromServer(fullUrl, domId);

            result.then(function() {
                selectedArtistLetter = getUrlVars().artistFilter;
                view.build();
                view.bind();
                view.setArtistDropdownLetter(selectedArtistLetter);
            });

        };

        var updatePlaylist = function(playlist, mode) {

            if (initialPlaylistCall) {

            }

            oldPlaylist = currentPlaylist;
            currentPlaylist = playlist.entries;
            repeatEnabled = playlist.repeatEnabled;
            gain = playlist.gain;
            stopped = playlist.stopEnabled;

            PlaylistView.getInstance().updateStoppedMsg(stopped);
            PlaylistView.getInstance().updateRepeatText(repeatEnabled);
            PlaylistView.getInstance().updatePlaylist(currentPlaylist, currentStreamUrl);

            if (mode === PLAYLIST_MODES.PLAY && currentPlaylist.length > 0) {
                _skip(0);
            }

            if (currentPlaylist.length === 0 && !XBMCManager.getInstance().isXBMCSyncEnabled() && webPlayer) {
                SubsonicWebPlayer.getInstance().stop();
            }

            if (playlist.sendM3U) {
                PlaylistView.getInstance().sendM3U();
            }

            if (sliderEnabled) {
                SubsonicWebSlider.getInstance().setValue(gain * 100);
            }


        };

        var getPlaylistPosForSongId = function(subsonicSongId) {
            for (var i = 0; i < currentPlaylist.length; i++) {
                if (currentPlaylist[i].trackId === subsonicSongId) {
                    return i;
                }
            }
            return -1;
        };

        var sendPlaylistCommand = function(method /* arguments */) {
            var argsCopy = Array.prototype.slice.call(arguments, 0),
                method = argsCopy.shift();
            _sendPlaylistCommand(method, argsCopy, false);
        };

        var sendUnproxiedPlaylistCommand = function(method /* arguments */) {
            var argsCopy = Array.prototype.slice.call(arguments, 0),
                method = argsCopy.shift();
            _sendPlaylistCommand(method, argsCopy, true);
        };

        var isWebPlayer = function() {
            return webPlayer;
        };


        return {
            sendPlaylistCommand: sendPlaylistCommand,
            getPlaylistPosForSongId: getPlaylistPosForSongId,
            sendUnproxiedPlaylistCommand: sendUnproxiedPlaylistCommand,
            updatePlaylist: updatePlaylist
        };
    };

    return {
        getInstance: function() {
            if (!instance)
                throw "PlaylistController not constructed yet";
            return instance;
        },
        constructor: function() {
            if (instance)
                throw "PlaylistController already constructed";
            instance = constructor.apply(null, arguments);
            return instance;
        }
    };

})();