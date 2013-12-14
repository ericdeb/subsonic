<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<html><head>
    <%@ include file="head.jspf" %>
    <link href="<c:url value="/style/shadow.css"/>" rel="stylesheet">
    <style>

		a:hover {
			text-decoration: none;
		}

		span {
			font-family: verdana, arial, sans-serif;
		}

		#recLinks {
			margin-top: 7px;
			font-weight: bold;
		}

		#secondHeader {
			margin-top: 25px;
			color: #E2E2E2;
			font-size: 26px;
			font-weight: bold;
			margin-bottom: 0px;
		}

		#genreDesc {
			width:650px;
		}

	</style>
	<script type="text/javascript" language="javascript">

		function init() {
			$("#genreDesc a").attr("target", "_blank");
		}

	</script>
</head>
<body class="mainframe bgcolor1" onload="init()">


<div id="scrollWrapper">

    <div id="scrollContainer">

		<div style="line-height: 1.5; max-width: 900px; margin-top: 20px;">

		<c:if test="${not empty model.title}">
			<h1 style="color: #D01073; text-transform:capitalize; font-weight: normal">${model.title}</h1>
				<c:if test="${model.page == 0}">
					<c:if test="${not empty model.genreDescription}"><div id="genreDesc"><span>${model.genreDescription}</span></div></c:if>
					<div id="recLinks">
						<c:choose><c:when test="${not empty model.genre}">
							<a href="javascript:noop()" onclick="top.playlist.sendPlaylistCommand(P_CMDS.PLAY.GENRE_RADIO, new Array('${model.genre}')">Play ${model.title} radio</a>
						</c:when><c:otherwise>
							<a href="javascript:noop()" onclick="top.playlist.sendPlaylistCommand(P_CMDS.PLAY.GROUP_RADIO, new Array('$${model.group}')">Play group radio</a>
						</c:otherwise></c:choose>
					
					<span>| </span><a href="${model.url}" target="_blank">Browse last.fm</a>
					</div>
					<h1 id="secondHeader">Top artists</h1>
				</c:if>
			</div>

			<%@ include file="artists.jspf" %>
		 	
		    <sub:url value="genres.view" var="prevUrl">
		        <sub:param name="genre" value="${model.genre}"/>
		        <sub:param name="group" value="${model.group}"/>
		        <sub:param name="page" value="${model.page - 1}"/>
		    </sub:url>
		    <sub:url value="genres.view" var="nextUrl">
		        <sub:param name="genre" value="${model.genre}"/>
		        <sub:param name="group" value="${model.group}"/>
		        <sub:param name="page" value="${model.page + 1}"/>
		    </sub:url>

		    <div style="margin-bottom:30px; height: 20px;">
				<c:if test="${model.page > 0}"><div class="back" style="padding-left:0px"><a href="${prevUrl}" style="font-size:20px; float: left; margin-right: 11px"><fmt:message key="common.previous"/></a></div></c:if>
				<c:if test="${not empty model.morePages}"><div class="forward" style="padding-left:0px"><a href="${nextUrl}" style="font-size:20px; float: left"><fmt:message key="common.next"/></a></div></c:if>
			</div>
		 	
			<%@ include file="artistRecommendation.jspf" %>
		</c:if>

		<c:if test="${empty model.title}">
			<c:forEach items="${model.topTagsOccurrences}" var="topTagOccurrence">
			<span style="font-size: ${topTagOccurrence.occurrence}px;">
				<sub:url var="url" value="genres.view">
					<sub:param name="genre" value="${topTagOccurrence.tag}"/>
				</sub:url>
				<a href="${url}">${topTagOccurrence.tag}</a>
			</span>
			</c:forEach>
			<c:if test="${not empty model.lastFmGroups}"><hr width="10%"></c:if>
			<c:forEach items="${model.lastFmGroups}" var="group" varStatus="i">
				<sub:url var="url" value="genres.view">
					<sub:param name="group" value="${group.name}"/>
				</sub:url>
				<c:if test="${i.count > 1}">|</c:if>
				<a href="${url}">${group.name}</a>
			</c:forEach>
			<c:if test="${empty model.topTagsOccurrences and empty model.lastFmGroups}">
				<p>Please configure which genres to use <a href="tagSettings.view">here</a>.
			</c:if>
		</c:if>

		</div>
	</div>
</div>

</body></html>