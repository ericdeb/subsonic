
var PlaylistView = (function() {

    var instance = null;

    var constructor = function(captionCutoff, repeatMsg, clearConfirmMsg) {

    	var hideEmptyMsgTimer = null;


	    var _truncate = function(s) {
	        if (s && s.length > captionCutoff) {
	            return s.substring(0, captionCutoff) + "...";
	        }
	        return s;
	    }


	    // function getSelectedIndexes() {
	    //     var result = "";
	    //     for (var i = 0; i < songs.length; i++) {
	    //         if ($("songIndex" + (i + 1)).checked) {
	    //             result += "i=" + i + "&";
	    //         }
	    //     }
	    //     return result;
	    // }

	    // function selectAll(b) {
	    //     for (var i = 0; i < songs.length; i++) {
	    //         $("songIndex" + (i + 1)).checked = b;
	    //     }
	    // }

     //    var _removeSelectedTracks = function() {
     //        var indexes = new Array();
     //        var counter = 0;
     //        for (var i = 0; i < songs.length; i++) {
     //            var index = i + 1;
     //            if ($("songIndex" + index).checked) {
     //                indexes[counter++] = i;
     //            }
     //        }

            
     //        if (xbmcSync) {
     //            XBMCManager.getInstance().getRequestHandler().sendRemoveTracks(indexes);
     //            return;
     //        }
     //        playlistService.removeMany(indexes, playlistCallbackWrapper);
     //    }


  		var _updateEmptyMsg = function(show) {
	        clearTimeout(hideEmptyMsgTimer);

	        $("#empty").hide();

	        if (show) {
	        	hideEmptyMsgTimer = setTimeout(function() {
	        		$("#empty").show();
	        	}, 500)
	        }
  		}



  	  	// Public Functions
        var updateStoppedMsg = function(stopped) {
        	if ($("#start")) {
        		if (stopped) {
        			$("#start").hide();
                	$("#stop").show();
        		} else {
        			$("#start").show();
                	$("#stop").hide();
        		}
                
	        }
        }

        var updateRepeatText = function() {
        	// if ($("toggleRepeat")) {
	        //     var text = repeatEnabled ? "<fmt:message key="playlist.repeat_on"/>" : "<fmt:message key="playlist.repeat_off"/>";
	        //     dwr.util.setValue("toggleRepeat", text);
	        // }
        }

        var sendM3U = function () {
        	parent.frames.main.location.href="play.m3u?";
        }

        var displayClearConfirm = function() {
        	return confirm(clearConfirmMsg);
        }

        var updateCurrentPlayingImage = function(index) {
        	$(".currentImage").hide();
        	$("#currentImage" + index + 1).show();
        }

	    var updatePlaylist = function(newPlaylist, currentStreamUrl) {

	        // Delete all the rows except for the "pattern" row
	        dwr.util.removeAllRows("playlistBody", { filter:function(tr) {
	            return (tr.id != "pattern");
	        }});

	        // Create a new set cloned from the pattern row
	        for (var i = 0; i < newPlaylist.length; i++) {
	            var song  = newPlaylist[i];
	            var id = i + 1;
	            dwr.util.cloneNode("pattern", { idSuffix:id });

	            $("#trackNumber" + id).text(song.trackNumber);

	            if (song.streamUrl === currentStreamUrl) {
	            	$("#currentImage" + id).show();
	            }

	            $("#title" + id + ", #titleUrl" + id).text(_truncate(song.title)).attr("title", song.title);

	            $("#album" + id).text(_truncate(song.album)).attr("title", song.album);
	            $("albumUrl" + id).attr('href', "artist.view?id=" + song.artistId + "&albumId=" + song.albumId);

	            $("#artist" + id).text(_truncate(song.artist)).attr("title", song.artist);
	            $("#artistUrl" + id).attr('href', "artist.view?id=" + song.artistId);

	            $("#composer" + id).text(_truncate(song.composer)).attr("title", song.composer);
	            $("#genre" + id).text(song.genre);
	            $("#year" + id).text(song.year);
	            $("#bitrate" + id).text(song.bitRate);
	            $("#duration" + id).text(song.durationAsString);
	            $("#format" + id).text(song.format);
	            $("#filesize" + id).text(song.fileSize);

	            $("#pattern" + id).show();
	            $("#pattern" + id).addClass((i % 2 == 0) ? "bgcolor1" : "bgcolor2");

	        }

	        var _sendCmd = function(cmd, index) {
	    		PlaylistController.getInstance().sendPlaylistCommand(cmd, index);
	    	}

	        $(".removeSongBut").click(function() { 
	        	_sendCmd(PLAYLIST_COMMANDS.REMOVE, $(".removeSongBut").index(this)); 
	        });

	        $(".upBut").click(function() { 
	        	_sendCmd(PLAYLIST_COMMANDS.UP, $(".upBut").index(this)); 
	        });

	        $(".downBut").click(function() { 
	        	_sendCmd(PLAYLIST_COMMANDS.DOWN, $(".downBut").index(this)); 
	        });

	        $(".titleUrl").click(function() { 
	        	_sendCmd(PLAYLIST_COMMANDS.PLAY.TRACKS, $(".titleUrl").index(this)); 
	        });

	        _updateEmptyMsg(newPlaylist.length === 0);

	    }


	    var _bindClickEvents = function() {
	    	var _sendCmd = function(cmd) {
	    		PlaylistController.getInstance().sendPlaylistCommand(cmd);
	    	}

	    	$("#stopLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.STOP); });
	    	$("#startLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.START); });
	    	$("#prevLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.PREVIOUS); });
	    	$("#nextLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.NEXT); });
	    	$("#clearLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.CLEAR); });
	    	$("#shuffleLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.SHUFFLE); });
	    	$("#toggleLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.TOGGLE_REPEAT); });
	    	$("#undoLink").click(function() { _sendCmd(PLAYLIST_COMMANDS.UNDO); });
	    }

	    //Initialization Code
	    _bindClickEvents();

	     //    <!-- actionSelected() is invoked when the users selects from the "More actions..." combo box. -->
		    // function actionSelected(id) {
		    //     if (id == "top") {
		    //         return;
		    //     } else if (id == "loadPlaylist") {
		    //         parent.frames.main.location.href = "loadPlaylist.view?";
		    //     } else if (id == "savePlaylist") {
		    //         parent.frames.main.location.href = "savePlaylist.view?";
		    //     } else if (id == "downloadPlaylist") {
		    //         location.href = "download.view?player=${model.player.id}";
		    //     } else if (id == "sharePlaylist") {
		    //         parent.frames.main.location.href = "createShare.view?player=${model.player.id}&" + getSelectedIndexes();
		    //     } else if (id == "sortByTrack") {
		    //         onSortByTrack();
		    //     } else if (id == "sortByArtist") {
		    //         onSortByArtist();
		    //     } else if (id == "sortByAlbum") {
		    //         onSortByAlbum();
		    //     } else if (id == "selectAll") {
		    //         selectAll(true);
		    //     } else if (id == "selectNone") {
		    //         selectAll(false);
		    //     } else if (id == "removeSelected") {
		    //         onRemoveSelected();
		    //     } else if (id == "download") {
		    //         location.href = "download.view?player=${model.player.id}&" + getSelectedIndexes();
		    //     } else if (id == "appendPlaylist") {
		    //         parent.frames.main.location.href = "appendPlaylist.view?player=${model.player.id}&" + getSelectedIndexes();
		    //     }
		    //     $("moreActions").selectedIndex = 0;
		    // }

        return {
        	displayClearConfirm: displayClearConfirm,
            updateStoppedMsg: updateStoppedMsg,
            updateRepeatText: updateRepeatText,
            updatePlaylist: updatePlaylist,
            updateCurrentPlayingImage: updateCurrentPlayingImage,
            sendM3U: sendM3U
        }

    }

    return {
        getInstance: function() {
            if (!instance)
                throw "PlaylistView not constructed yet";
            return instance;
        },
        constructor: function() {
            if (instance)
                throw "PlaylistView already constructed";
            instance = constructor.apply(null, arguments);
            return instance;
        }
    };

})();