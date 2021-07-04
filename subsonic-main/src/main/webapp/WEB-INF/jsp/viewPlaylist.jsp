<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <%@ include file="head.jspf" %>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>    
    <script type="text/javascript" src="<c:url value="/dwr/interface/viewPlaylistService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/jwplayer.js"/>"></script> 
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>   
    <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/jquery-1.7.2.min.js"/>"></script>
    <link type="text/css" rel="stylesheet" href="<c:url value="/script/webfx/luna.css"/>">
    <style>
        .withSelectedOptions {
            position:relative;
            left: 7px;
            top: 2px;
            margin-left: 3px;
        }

        .checkbox {
            position: relative;
            bottom: 1px;
        }
    </style>
</head>

<body class="bgcolor2 playlistframe" onload="init()">

<script type="text/javascript" language="javascript">
    var songs = null;
    var currentArtistId = null;
    var currentAlbumId = null;
    var currentStreamUrl = null;
    var startPlayer = false;
    var repeatEnabled = false;
    var slider = null;

    function init() {
        dwr.engine.setErrorHandler(null);

        var playlistName = "${model.playlistName}";
        viewPlaylistService.getPlaylistFromName(playlistName, playlistCallback);

        $("#vPlayTop").click(function() {
            top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, getSelected(), P_MODES.PLAY);
        });

        $("#vEnqueuTop").click(function() {
            top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, getSelected(), P_MODES.ENQUEUE);
        });

        $("#vLastTop").click(function() {
            top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, getSelected(), P_MODES.ADD);
        });
    }

    function setTextAndTitle(el, text, title) {
        if (el)
            el.html(text).attr("title", title);
        return el;
    }

    function playlistCallback(playlist) {
        songs = playlist.entries;

        if (songs.length == 0) {
            $("#empty").show();
        } else {
            $("#empty").hide();
        }

        // Delete all the rows except for the "pattern" row
        dwr.util.removeAllRows("playlistBody", { filter:function(tr) {
            return (tr.id != "pattern");
        }});

        // Create a new set cloned from the pattern row
        for (var i = 0; i < songs.length; i++) {
            var song  = songs[i];
            var id = i + 1;
            var param = { 
                trackId: song.trackId 
            };

            dwr.util.cloneNode("pattern", { idSuffix:id });

            $("#trackNumber" + id).val(song.trackNumber);
            setTextAndTitle($("#title" + id), song.title, song.title);

            setTextAndTitle($("#titleUrl" + id), truncate(song.title), song.title)
                .click(param, function(e) {
                    top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.TRACKS, [e.data.trackId], 'P');
            });

            setTextAndTitle($("#albumUrl" + id), truncate(song.album), song.album)
                .attr("href", "artist.view?id=" + song.artistId + "&albumId=" + song.albumId);

            setTextAndTitle($("#artistUrl" + id), truncate(song.artist), song.artist)
                .attr("href", "artist.view?id=" + song.artistId);

            setTextAndTitle($("#composer" + id), truncate(song.composer), song.composer);

            $("#genre" + id).html(song.genre);
            $("#year" + id).html(song.year);
            $("#bitRate" + id).html(song.bitRate);
            $("#duration" + id).html(song.durationAsString);
            $("#format" + id).html(song.format);
            $("#fileSize" + id).html(song.fileSize);

            $("#vPlay" + id).click(param, function(e) {
                top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.TRACKS, [e.data.trackId], 'P');
            });

            $("#vEnqueue" + id).click(param, function(e) {
                top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.TRACKS, [e.data.trackId], 'E');
            });

            $("#vLast" + id).click(param, function(e) {
                top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.TRACKS, [e.data.trackId], 'A');
            });

            $("#pattern" + id).show();
            $("#pattern" + id).className = (i % 2 == 0) ? "bgcolor1" : "bgcolor2";
        }

    }

    function truncate(s) {
        var cutoff = ${model.visibility.captionCutoff};

        if (s.length > cutoff) {
            return s.substring(0, cutoff) + "...";
        }
        return s;
    }

    function selectAll(b) {
        for (var i = 0; i < songs.length; i++) {
            $("#songIndex" + (i + 1)).attr("checked", b);
        }
    }

    function getSelected() {
        var selectedSongs = [];
        for (var i = 0; i < songs.length; i++) { 
            if ($("#songIndex" + (i + 1)).attr("checked")) {
                 selectedSongs.push(songs[i].trackId);
            }
        }
        return selectedSongs;
    }

    function downloadSelected() {
        var selectedSongs = [];
        var result = '';
        for (var i = 0; i < songs.length; i++) { 
            if ($("#songIndex" + (i + 1)).attr("checked")) {
                selectedSongs.push(songs[i].trackId);
                // result += "i=" + songs[i].trackId + "&";
            }
        }
        location.href = "download.view?id=" + unescape(encodeURIComponent(selectedSongs));
    }


</script>

<h1 id="name" style="color: #D01073">${model.trimmedName}</h1>
<div class="bgcolor2" style="width:100%;padding-top:0.8em; padding-top:0.5em">
    <table style="white-space:nowrap;">
        <tr style="white-space:nowrap;">
            <td style="white-space:nowrap; padding-right: 4px"><span style="font-weight: bold">Select</span></td>
            <td style="white-space:nowrap; padding-left:0.2em; padding-right: 4px"><a href="javascript:noop()" onclick="selectAll(true)">All</a></td>
            <td style="white-space:nowrap; padding-left:0.2em;"><a href="javascript:noop()" onclick="selectAll(false)">None</a></td>
			<td></td>
			<td style="white-space:nowrap; padding-left:0.8em;"><span style="font-weight: bold">With Selected: </span></td>
			<td><a id="vPlayTop" href="javascript:noop()" class="withSelectedOptions"><img src="<spring:theme code="playImage"/>" alt="Play" title="Play"></a></td>
            <td><a id="vEnqueueTop" href="javascript:noop()" class="withSelectedOptions"><img src="<spring:theme code="enqueueImage"/>" alt="Enqueue" title="Enqueue"></a></td>
            <td><a id="vLastTop" href="javascript:noop()" class="withSelectedOptions"><img src="<spring:theme code="addImage"/>" alt="Add" title="Add"></a></td>
            <td><a href="javascript:noop()" onclick="downloadSelected()" class="withSelectedOptions"><img src="<spring:theme code="downloadImage"/>"></a></td>
        </tr>
     </table>
</div>

<p id="empty" style="display: none"><em><fmt:message key="playlist.empty"/></em></p>

<table style="border-collapse:collapse;white-space:nowrap; margin-top:7px">
    <tbody id="playlistBody">
        <tr id="pattern" style="display:none;margin:0;padding:0;border:0">

            <td class="bgcolor2" style="padding-left: 0.1em; padding-right:1em"><input type="checkbox" class="checkbox" id="songIndex"></td>
            <td style="padding-right:0.25em"></td>

            <c:if test="${model.visibility.trackNumberVisible}">
                <td style="padding-right:0.5em;text-align:right"><span class="detail" id="trackNumber">1</span></td>
            </c:if>

            <td style="padding-right:1.25em">
                <img id="currentImage" src="<spring:theme code="currentImage"/>" alt="" style="display:none">
                <c:choose>
                    <c:when test="${model.player.externalWithPlaylist}">
                        <span id="title">Title</span>
                    </c:when>
                    <c:otherwise>
                        <a id="titleUrl" href="javascript:noop()">Title</a>
                    </c:otherwise>
                </c:choose>
            </td>


            
            <c:if test="${model.visibility.artistVisible}"><td style="padding-right:1.25em; padding-left: 3em;"><a id="artistUrl" target="main"><span class="detail">Artist</span></a></td></c:if>
            <c:if test="${model.visibility.albumVisible}"><td style="padding-right:1.25em; padding-left: 3em;"><a id="albumUrl" target="main"><span class="detail">Album</span></a></td></c:if>
            <c:if test="${model.visibility.composerVisible}"><td style="padding-right:1.25em"><span id="composer" class="detail">Composer</span></td></c:if>
            <c:if test="${model.visibility.genreVisible}"><td style="padding-right:1.25em"><span id="genre" class="detail">Genre</span></td></c:if>
            <c:if test="${model.visibility.yearVisible}"><td style="padding-right:1.25em; padding-left: 3em"><span id="year" class="detail">Year</span></td></c:if>

            <c:if test="${empty model.playlistName}">
                <c:if test="${model.visibility.formatVisible}"><td style="padding-right:1.25em"><span id="format" class="detail">Format</span></td></c:if>
                <c:if test="${model.visibility.fileSizeVisible}"><td style="padding-right:1.25em;text-align:right;"><span id="fileSize" class="detail">Size</span></td></c:if>
            </c:if>

            <c:if test="${model.visibility.durationVisible}"><td style="padding-right:1.25em;text-align:right;"><span id="duration" class="detail">Duration</span></td></c:if>

            <c:choose>
                <c:when test="${empty model.playlistName}">
                    <c:if test="${model.visibility.bitRateVisible}"><td style="padding-right:0.25em"><span id="bitRate" class="detail">Bit Rate</span></td></c:if>
                </c:when>
                <c:otherwise>
                    <td><a id="vPlay" href="javascript:noop()"><img src="<spring:theme code="playImage"/>" alt="Play" title="Play"></a></td>
                    <td><a id="vEnqueue" href="javascript:noop()"><img src="<spring:theme code="enqueueImage"/>" alt="Enqueue" title="Enqueue"></a></td>
                    <td><a id="vLast" href="javascript:noop()"><img src="<spring:theme code="addImage"/>" alt="Add" title="Add"></a></td>
                </c:otherwise>
            </c:choose>
        </tr>
    </tbody>
</table>

</body></html>