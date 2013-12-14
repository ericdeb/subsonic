<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%--@elvariable id="command" type="net.sourceforge.subsonic.command.SearchCommand"--%>

<html><head>
    <%@ include file="head.jspf" %>
	<script type="text/javascript" src="<c:url value="/script/jquery-1.7.2.min.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/dwr/interface/uiStarService.js"/>"></script>
    <style>
        a:hover, a:hover {
            text-decoration: none;
        }

        h1, h2, h3 {
            color: #E2E2E2;
        }

        h2 {
            font-size:26px;
            line-height: 20px;
        }
    </style>

    <script type="text/javascript">
    function init() {
        dwr.engine.setErrorHandler(null);
	}

    function noop() {}
	</script>

</head>
<body class="mainframe bgcolor1" onload="init()">

<div id="scrollWrapper">

    <div id="scrollContainer">

    <%@ include file="toggleStar.jspf" %>

    <h1 style="color: #D01073; font-weight:normal">Search Results</h1>
<!-- 
    <form:form commandName="command" method="post" action="search.view" name="searchForm">
        <table>
            <tr>
                <td><fmt:message key="search.query"/></td>
                <td style="padding-left:0.25em"><form:input path="query" size="35"/></td>
                <td style="padding-left:0.25em"><input type="submit" onclick="search(0)" value="<fmt:message key="search.search"/>"/></td>
            </tr>
        </table>

    </form:form> -->

    <c:if test="${not command.indexCreated}">
        <p class="warning"><fmt:message key="search.index"/></p>
    </c:if>

    <c:if test="${command.indexCreated and empty command.artists and empty command.albums and empty command.songs}">
        <p class="warning"><fmt:message key="search.hits.none"/></p>
    </c:if>

    <c:if test="${not empty command.artists}">
        <h2><fmt:message key="search.hits.artists"/></h2>
        <table style="border-collapse:collapse; margin-bottom:40px">
            <c:forEach items="${command.artists}" var="artist" varStatus="loopStatus">

                <sub:url value="/artist.view" var="artistUrl">
                    <sub:param name="id" value="${artist.id}"/>
                </sub:url>

                <tr>
                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-left:0.25em;padding-right:1.25em">
                        <a href="${artistUrl}">${artist.name}</a>
                    </td>
                </tr>

                </c:forEach>
        </table>
    </c:if>

    <c:if test="${not empty command.albums}">
        <h2><fmt:message key="search.hits.albums"/></h2>
        <table style="border-collapse:collapse; margin-bottom:40px">
            <c:forEach items="${command.albums}" var="album" varStatus="loopStatus">

    			<sub:url value="/artist.view" var="artistUrl">
                    <sub:param name="id" value="${album.artist.id}"/>
                </sub:url>

                <sub:url value="/artist.view" var="albumUrl">
                    <sub:param name="id" value="${album.artist.id}"/>
                    <sub:param name="albumId" value="${album.id}"/>
                </sub:url>

                <tr>
                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-left:0.25em;padding-right:1.25em">
                        <a href="${albumUrl}">${album.name}</a>
                    </td>

                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-right:0.25em;padding-left: 3em">
                        <a href="${artistUrl}">${album.artist.name}</a>
                    </td>
                </tr>

                </c:forEach>
        </table>
    </c:if>

    <c:if test="${not empty command.songs}">
        <h2><fmt:message key="search.hits.songs"/></h2>
        <table style="border-collapse:collapse; margin-bottom: 40px">
            <c:forEach items="${command.songs}" var="track" varStatus="loopStatus">

    			<sub:url value="/artist.view" var="artistUrl">
                    <sub:param name="id" value="${track.metaData.artistId}"/>
                </sub:url>

                <sub:url value="/artist.view" var="albumUrl">
                    <sub:param name="id" value="${track.metaData.artistId}"/>
                    <sub:param name="albumId" value="${track.metaData.albumId}"/>
                </sub:url>

                <tr>
                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-left:0.25em;padding-right:1.25em">
                        <a onclick="top.playlist.sendPlaylistCommand(P_CMDS.PLAY.TRACKS, [${track.id}], P_MODES.PLAY);"
                            href="javascript:noop()">${track.name}</a>
                    </td>

                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-right:0.25em; padding-left: 3em">
                        <a href="${artistUrl}">${track.metaData.artist}</a>
                    </td>

                    <td ${loopStatus.count % 2 == 1 ? "class='bgcolor2'" : ""} style="padding-right:1.25em; padding-left: 3em">
                        <a href="${albumUrl}">${track.metaData.album}</a>
                    </td>

                    <c:import url="playAddDownload.jsp">
                        <c:param name="id" value="[${track.id}]"/>
                        <c:param name="starred" value="${command.isTrackStarred[loopStatus.index]}"/>
                        <c:param name="starId" value="${track.id}"/>
                        <c:param name="playEnabled" value="${command.user.streamRole and not command.partyModeEnabled}"/>
                        <c:param name="enqueueEnabled" value="${command.user.streamRole}"/>
                        <c:param name="addEnabled" value="${command.user.streamRole}"/>
                        <c:param name="downloadEnabled" value="${command.user.downloadRole and not command.partyModeEnabled}"/>
                        <c:param name="asTable" value="true"/>
                    </c:import>

                </tr>

                </c:forEach>
        </table>
    </c:if>
<!-- 
    <h2 style="font-size:26px; color: #E2E2E2">Advanced search</h2>
    <sub:url value="/advancedSearch.view" var="advancedSearchUrl">
    	<sub:param name="searchQuery" value="${command.query}"/>
    </sub:url>
    <div class="forward" style="margin-bottom: 30px"><a href="${advancedSearchUrl}">Search for '${command.query}' in advanced mode</a></div>
    </div> -->
</div>
</body></html>