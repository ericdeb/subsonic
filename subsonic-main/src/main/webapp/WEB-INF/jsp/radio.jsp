<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<html><head>
    <%@ include file="head.jspf" %>

    <style type="text/css">
span.off {
    cursor: pointer;
    float:left;
    padding: 2px 6px;
    margin: 2px;
    background: #FFF;
    color: #000;
    -webkit-border-radius: 7px;
    -moz-border-radius: 7px;
    border-radius: 7px;
    border: solid 1px #CCC;
    text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.2);
    -webkit-transition-duration: 0.1s;
    -moz-transition-duration: 0.1s;
    transition-duration: 0.1s;
    -webkit-user-select:none;
    -moz-user-select:none;
    -ms-user-select:none;
    user-select:none;
    white-space: nowrap;
}

span.on {
    cursor: pointer;
    float:left;
    padding: 2px 6px;
    margin: 2px;
    background: #6A4;
    color: #000;
    -webkit-border-radius: 7px;
    -moz-border-radius: 7px;
    border-radius: 7px;
    border: solid 1px #444;
    text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.2);
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.6);
    -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.6);
    box-shadow: inset 0 0px 1px rgba(0, 0, 0, 0.6);
    -webkit-transition-duration: 0.1s;
    -moz-transition-duration: 0.1s;
    transition-duration: 0.1s;
    -webkit-user-select:none;
    -moz-user-select:none;
    -ms-user-select:none;
    user-select:none;
    white-space: nowrap;
}

span.off:hover {
    background: #6A4;
    border: solid 1px #666;
    text-decoration: none;
}

#playRadio {
    position: relative;
    top: 40px;
    font-size: 32px;
}

a:hover, a:hover {
    text-decoration: none;
    color: #005580;
}

</style>
    
<script type="text/javascript">

function init() {

    $(".radioBut").click(function() {
        var rem = 'on', add = 'off';
        if ($(this).hasClass("off")) {
            rem = 'off', add='on';
        }
        $(this).removeClass(rem).addClass(add);
    })

}
function playGenreRadio() {
    var genres = new Array();
    $('span.on').each(function() {
        genres.push($(this).text());
    });
    top.playlist.sendPlaylistCommand(PLAYLIST_COMMANDS.PLAY.GENRE_RADIO, genres);
}

function noop() {}


</script>

</head>
<body class="mainframe bgcolor1" onload="init()">

<div id="scrollWrapper" style="max-width:900px">

    <div id="scrollContainer" style="padding-top:40px;">

        <c:choose>
            <c:when test="${empty model.topTags}">
                <p>Please configure which genres to use <a href="tagSettings.view">here</a>.
            </c:when>
            <c:otherwise>
                <div style="margin-bottom: 30px">
                    <span style="font-size: 40px; color: #D01073">Choose one or more genres:</span>
                </div>

                <c:forEach items="${model.topTags}" var="topTag">
                    <span class="radioBut off">${topTag}</span>
                </c:forEach>

                <div style="clear:both"/>

                <div>
                    <a id="playRadio" onClick="playGenreRadio();" href="javascript:noop()">Play Radio </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body></html>