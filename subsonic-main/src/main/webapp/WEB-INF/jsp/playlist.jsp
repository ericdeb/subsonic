<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <%@ include file="head.jspf" %>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>    
    <script type="text/javascript" src="<c:url value="/dwr/interface/nowPlayingService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/playlistService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/jwplayer.js"/>"></script>    
    <script type="text/javascript" src="<c:url value="/script/jquery-1.7.2.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/range.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/timer.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/webfx/slider.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/PlaylistCommands.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/PlaylistController.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/PlaylistView.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/SubsonicPlaylistService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/SubsonicWebPlayer.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/SubsonicWebSlider.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/XBMCManager.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/XBMCPlaylistProxy.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/XBMCRequestHandler.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/XBMCRequestParamService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/script/XBMCResponseHandler.js"/>"></script>
    <link type="text/css" rel="stylesheet" href="<c:url value="/script/webfx/luna.css"/>">
</head>

<body class="bgcolor2 playlistframe" onload="init()">

<script type="text/javascript" language="javascript">

    function init() {
        dwr.engine.setErrorHandler(null);

        var webPlayer = '${model.player.web}' === 'true',
            partyMode = '${model.partyMode}' === 'true',
            slider = '${model.player.jukebox}' === 'true',
            captionCutoff = '${model.visibility.captionCutoff}',
            clearConfirmMsg = partyMode ? '<fmt:message key="playlist.confirmclear"/>' : '';

        var xbmcSync = /* true || eval("${model.xbmc}") || */ true;

        // construct what's necessary
        XBMCManager.constructor(xbmcSync);
        PlaylistView.constructor(captionCutoff, null, clearConfirmMsg);
        PlaylistController.constructor(webPlayer, partyMode);
        

        // define accessible global
        sendPlaylistCommand = PlaylistController.getInstance().sendPlaylistCommand;

        if (webPlayer) {
            var backgroundColor = "<spring:theme code="backgroundColor"/>",
                frontColor = "<spring:theme code="textColor"/>",
                flashSrc = '<c:url value="/flash/jw-player-5.10.swf"/>';

            SubsonicWebPlayer.constructor(backgroundColor, frontColor, flashSrc);
        } else {
            PlaylistController.getInstance().sendPlaylistCommand(PLAYLIST_COMMANDS.GET_PLAYLIST);
        }

        if (slider) {
            SubsonicWebSlider.constructor(jQuery("#slider-1"), jQuery("#slider-input-1"));
        }

        
    }

    

</script>

<div id="testLove"></div>

<c:choose>
    <c:when test="${empty model.playlistName}">
        <div class="bgcolor2" style="position:fixed; top:0; width:100%;padding-top:0.5em">
            <table style="white-space:nowrap;">
                <tr style="white-space:nowrap;">
                    <c:if test="${model.user.settingsRole}">
                        <td><select name="player" onchange="location='playlist.view?player=' + options[selectedIndex].value;">
                            <c:forEach items="${model.players}" var="player">
                                <option ${player.id eq model.player.id ? "selected" : ""} value="${player.id}">${player.shortDescription}</option>
                            </c:forEach>
                        </select></td>
                    </c:if>
                    <c:if test="${model.player.web}">
                        <td style="width:340px; height:24px;padding-left:10px;padding-right:10px"><div id="mediaplayer">
                            <p>Loading the player ...</p>
                        </div></td>
                    </c:if>

                    <c:if test="${model.user.streamRole and not model.player.web}">
                        <td style="white-space:nowrap;" id="stop"><b><a id="stopLink" href="javascript:noop()"><fmt:message key="playlist.stop"/></a></b> | </td>
                        <td style="white-space:nowrap;" id="start"><b><a id="startLink" href="javascript:noop()"><fmt:message key="playlist.start"/></a></b> | </td>
                    </c:if>

                    <c:if test="${model.player.jukebox}">
                        <td style="white-space:nowrap;">
                            <img src="<spring:theme code="volumeImage"/>" alt="">
                        </td>
                        <td style="white-space:nowrap;">
                            <div class="slider bgcolor2" id="slider-1" style="width:90px">
                                <input class="slider-input" id="slider-input-1" name="slider-input-1">
                            </div>
                        </td>
                    </c:if>

                    <c:if test="${model.player.web}">
                        <td style="white-space:nowrap;"><a id="prevLink" href="javascript:noop()"><b>&laquo;</b></a></td>
                        <td style="white-space:nowrap;"><a id="nextLink" href="javascript:noop()"><b>&raquo;</b></a> |</td>
                    </c:if>

                    <td style="white-space:nowrap;"><a id="clearLink" href="javascript:noop()"><fmt:message key="playlist.clear"/></a> |</td>
                    <td style="white-space:nowrap;"><a id="shuffleLink" href="javascript:noop()"><fmt:message key="playlist.shuffle"/></a> |</td>

                    <c:if test="${model.player.web or model.player.jukebox or model.player.external}">
                        <td style="white-space:nowrap;"><a href="javascript:noop()" id="toggleLink"><span id="toggleRepeat"><fmt:message key="playlist.repeat_on"/></span></a> |</td>
                    </c:if>

                    <td style="white-space:nowrap;"><a href="javascript:noop()" id="undoLink"><fmt:message key="playlist.undo"/></a> |</td>

                    <c:if test="${model.user.settingsRole}">
                        <td style="white-space:nowrap;"><a href="playerSettings.view?id=${model.player.id}" target="main"><fmt:message key="playlist.settings"/></a> |</td>
                    </c:if>

                    <td style="white-space:nowrap;"><select id="moreActions" onchange="actionSelected(this.options[selectedIndex].id)">
                        <option id="top" selected="selected"><fmt:message key="playlist.more"/></option>
                        <option style="color:blue;"><fmt:message key="playlist.more.playlist"/></option>
                        <option id="loadPlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.load"/></option>
                        <c:if test="${model.user.playlistRole}">
                            <option id="savePlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.save"/></option>
                        </c:if>
                        <c:if test="${model.user.downloadRole}">
                            <option id="downloadPlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="common.download"/></option>
                        </c:if>
                        <c:if test="${model.user.shareRole}">
                            <option id="sharePlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="main.more.share"/></option>
                        </c:if>
                        <option id="sortByTrack">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbytrack"/></option>
                        <option id="sortByAlbum">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbyalbum"/></option>
                        <option id="sortByArtist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.sortbyartist"/></option>
                        <option style="color:blue;"><fmt:message key="playlist.more.selection"/></option>
                        <option id="selectAll">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.selectall"/></option>
                        <option id="selectNone">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.more.selectnone"/></option>
                        <option id="removeSelected">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.remove"/></option>
                        <c:if test="${model.user.downloadRole}">
                            <option id="download">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="common.download"/></option>
                        </c:if>
                        <c:if test="${model.user.playlistRole}">
                            <option id="appendPlaylist">&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="playlist.append"/></option>
                        </c:if>
                    </select>
                    </td>

                </tr></table>
        </div>
    </c:when>
    <c:otherwise>
        <h1 id="name">${model.playlistName}</h1>
    </c:otherwise>
</c:choose>

<div style="height:3.2em"></div>

<p id="empty" style="display: none"><em><fmt:message key="playlist.empty"/></em></p>

<table style="border-collapse:collapse;white-space:nowrap;">
    <tbody id="playlistBody">
        <tr id="pattern" style="display:none;margin:0;padding:0;border:0">
            <td class="bgcolor2"><a href="javascript:noop()">
                <img id="removeSong" class="removeSongBut" src="<spring:theme code="removeImage"/>"
                     alt="<fmt:message key="playlist.remove"/>" title="<fmt:message key="playlist.remove"/>"></a></td>
            <td class="bgcolor2"><a href="javascript:noop()">
                <img id="up" class="upBut" src="<spring:theme code="upImage"/>"
                     alt="<fmt:message key="playlist.up"/>" title="<fmt:message key="playlist.up"/>"></a></td>
            <td class="bgcolor2"><a href="javascript:noop()">
                <img id="down" class ="downBut" src="<spring:theme code="downImage"/>"
                     alt="<fmt:message key="playlist.down"/>" title="<fmt:message key="playlist.down"/>"></a></td>

            <td class="bgcolor2" style="padding-left: 0.1em"><input type="checkbox" class="checkbox" id="songIndex"></td>
            <td style="padding-right:0.25em"></td>

            <c:if test="${model.visibility.trackNumberVisible}">
                <td style="padding-right:0.5em;text-align:right"><span class="detail" id="trackNumber">1</span></td>
            </c:if>

            <td style="padding-right:1.25em">
                <img id="currentImage" class="currentImage" src="<spring:theme code="currentImage"/>" alt="" style="display:none">
                <c:choose>
                    <c:when test="${model.player.externalWithPlaylist}">
                        <span id="title">Title</span>
                    </c:when>
                    <c:otherwise>
                        <a id="titleUrl" class="titleUrl" href="javascript:noop()">Title</a>
                    </c:otherwise>
                </c:choose>
            </td>

            <c:if test="${model.visibility.artistVisible}"><td style="padding-right:1.25em"><a id="artistUrl" target="main"><span id="artist" class="detail">Artist</span></a></td></c:if>
            <c:if test="${model.visibility.albumVisible}"><td style="padding-right:1.25em"><a id="albumUrl" target="main"><span id="album" class="detail">Album</span></a></td></c:if>
            <c:if test="${model.visibility.composerVisible}"><td style="padding-right:1.25em"><span id="composer" class="detail">Composer</span></td></c:if>
            <c:if test="${model.visibility.genreVisible}"><td style="padding-right:1.25em"><span id="genre" class="detail">Genre</span></td></c:if>
            <c:if test="${model.visibility.yearVisible}"><td style="padding-right:1.25em"><span id="year" class="detail">Year</span></td></c:if>

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
                    <td>
                        <a id="playLink" href="javascript:noop()" onclick="sendPlaylistCommand(P_CMDS.PLAY.TRACKS, [${track.id}], P_MODES.PLAY);">
                        <img src="<spring:theme code="playImage"/>" alt="Play" title="Play"></a>
                    </td>
                    <td>
                        <a id="enqueueLink" href="javascript:noop()" onclick="sendPlaylistCommand(P_CMDS.PLAY.TRACKS, [${track.id}], P_MODES.ENQUEUE);">
                        <img src="<spring:theme code="enqueueImage"/>" alt="Enqueue" title="Enqueue"></a>
                    </td>
                    <td>
                        <a id="addLink" href="javascript:noop()" onclick="sendPlaylistCommand(P_CMDS.PLAY.TRACKS, [${track.id}], P_MODES.ADD);">
                        <img src="<spring:theme code="addImage"/>" alt="Add" title="Add"></a>
                    </td>
                </c:otherwise>
            </c:choose>
        </tr>
    </tbody>
</table>

</body></html>