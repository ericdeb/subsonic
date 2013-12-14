<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html><head>
    <%@ include file="head.jspf" %>
    <link href="<c:url value="/style/shadow.css"/>" rel="stylesheet">
    <script type="text/javascript" src="<c:url value="/script/prototype.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/script/jquery-1.7.2.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/dwr/interface/uiStarService.js"/>"></script>
</head>
<style>
    #topLinks, #topLinks a {
        font-size:24px;
    }

    #topLinks {
        margin-top:20px;
        margin-bottom:20px;
    }

    .bigLine {
        color: #E2E2E2;
    }

    .headerSelected {
        color: #D01073;
    }

    .forward, .back {
        margin-bottom: 30px;
        font-size: 20px;
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        float: left;

    }

    .detail {
        font-size: 14px;
    }
/*
    .forward a, .back a {
        color: #D01073;
    }*/

    a:hover, a:hover {
        text-decoration: none;
    }

    span {
        cursor: default;
    }

    .homeSubLinks {
        float: left;
    }

    .homeSubLinks *, #meEveryone {
        font-size: 20px;
    }

    #meEveryone {
        float: right;
    }

    .homeSubLinksWrapper {
        max-width: 1070px;
        height:30px;
        margin-bottom:15px;
    }

    #homeSearch {
        margin-top:5px;
    }

    .artistWrapper {
        margin-left: 2px;
        margin-right: 2px;
    }

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
<body class="mainframe bgcolor1" onload="init()">

<%@ include file="toggleStar.jspf" %>

<script type="text/javascript" language="javascript">

    function noop() {}

    function init() {
        dwr.engine.setErrorHandler(null);
        $(".artistGenre").each(function() {
            var res = toCamelCase($(this).text())
            $(this).text(res);
        });

        $("#topLinks a").each(function() {
            if ($(this).text() === 'Starred') {
                $(this).css('display', 'none');
                $(this).next().css('display', 'none');
            }
        })
	}

    function toCamelCase(str){
        return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    };

    function selectAll(b) {
        $(".songIndex").attr('checked', b);
    }

    function getSelected() {
        var selectedSongs = [];
        $(".songIndex").each(function() {
            if ($(this).prop('checked')) {
                selectedSongs.push($(this).next().val());
            }
            
        })
        return selectedSongs;
    }

    function downloadSelected() {
        location.href = "download.view?id=" + unescape(encodeURIComponent(getSelected()));
    }
</script>

<div id="scrollWrapper">

    <div id="scrollContainer">
<!-- 
        <h1>
            <img src="<spring:theme code="homeImage"/>" alt="">
            ${model.welcomeTitle}
        </h1>

        <c:if test="${not empty model.welcomeSubtitle}">
            <h2>${model.welcomeSubtitle}</h2>
        </c:if> -->

        <c:if test="${model.admin}">
            <c:if test="${model.isIndexBeingCreated}">
                <p class="warning"><fmt:message key="home.scan"/></p>
            </c:if>

            <c:if test="${empty model.lastFmUser}">
                <div>
                    <span style="color: red">
                        Last.fm scrobbling not configured! For full statistics and personal music recommendations, <a href="lastFmSettings.view">click here</a>.
                    </span>
                </div>
            </c:if>
        </c:if>

        <div id="topLinks">
            <c:forTokens items="newest recent frequent topartists random recommended" delims=" " var="cat" varStatus="loopStatus">
                <c:if test="${loopStatus.count > 1}"><span class="bigLine">&nbsp;|&nbsp;</span></c:if>
                <sub:url var="url" value="home.view">
                    <sub:param name="listType" value="${cat}"/>
                </sub:url>

                <c:choose>
                    <c:when test="${model.listType eq cat}">
                        <span class="headerSelected"><fmt:message key="home.${cat}.title"/></span>
                    </c:when>
                    <c:otherwise>
                        <a href="${url}"><fmt:message key="home.${cat}.title"/></a>
                    </c:otherwise>
                </c:choose>

            </c:forTokens>
        </div>

        <c:if test="${not model.listType eq 'topartists'}"><h2><fmt:message key="home.${model.listType}.text"/></h2></c:if>

        <table width="100%">
            <tr>
                <td style="vertical-align:top;">


                    <c:if test="${model.listType eq 'newest'}"><%@ include file="homeQuery.jspf" %><%@ include file="homeAlbums.jspf" %></c:if>
                    <c:if test="${model.listType eq 'recent' or model.listType eq 'frequent' or model.listType eq 'starred' or model.listType eq 'random'}">
                    	<%@ include file="homeArtistAlbumSongMenu.jspf" %>
                    </c:if>
                    <c:if test="${model.listType eq 'topartists'}"><%@ include file="homeTopArtists.jspf" %></c:if>
                    <c:if test="${model.listType eq 'recommended'}"><%@ include file="homeArtists.jspf" %><%@ include file="artistRecommendation.jspf" %></c:if>

                </td>
<!--                 <c:if test="${not empty model.welcomeMessage}">
                    <td style="vertical-align:top;width:20em">
                        <div style="padding:0 1em 0 1em;border-left:1px solid #<spring:theme code="detailColor"/>">
                            <sub:wiki text="${model.welcomeMessage}"/>
                        </div>
                    </td>
                </c:if> -->
            </tr>
        </table>
    </div>
</div>

</body></html>
