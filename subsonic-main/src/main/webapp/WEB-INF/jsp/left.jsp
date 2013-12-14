<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
	<%@ include file="head.jspf" %>
	<script type="text/javascript" src="<c:url value="/script/scripts.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/script/smooth-scroll.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/util.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/libraryStatusService.js"/>"></script>
    <style>
    .leftHeader {
        font-size: 26px;
        font-weight:bold;
        margin-bottom:6px;
        margin-top:10px;
    }
    .leftFilter {
        font-size: 18px;
        margin-top:10px;
    }

    #artistFilterDiv {
    	font-size: 18px;
		margin-top: 12px;
		margin-bottom: 2px;
		position: relative;
		left: 1px;
		cursor: default;
    }

    #artistDropdown {
    	margin-top:1px;	
    }

    #tag, #artistDropdown select {
    	width: auto;
		font-size: 12px;
		height: 22px;
		padding: 0px;
		margin-top: 2px;
    }

    .artistLinks p {
    	font-size:12px;
    	padding-left:4px;
    }

    html, body {
		padding: 0;
		margin: 0;
	 	overflow: hidden;
	 	height:100%;
	 	width:100%;
	}

	#container {
		padding-left: 20px;
		height:100%;
	}

	#innerDivWrapper {
		padding:0;
		overflow:hidden;
		margin-top:6px;
	}

	#innerContainer {
		position: relative;
		left: 0;
		right: -30px;
		padding-right: 20px;
		overflow-y: scroll;
		overflow-x: hidden;
		height:100%;
		width:100%;
	}

    </style>
	<script type="text/javascript">

        var artistDropdown = 'All';

	    function init() {
	        dwr.engine.setErrorHandler(null);
	        dwr.engine.setActiveReverseAjax(true);
	        dwr.engine.setNotifyServerOnPageUnload(true);
	 
	        $('#tag').change(function() {
	        	window.location = $(this).val() + '&artistFilter=' + artistDropdown;
	        });

	        $(".playlistName").each(function() {
	        	var str = $(this).text();
	        	var dotIndex = str.indexOf('.');
	        	$(this).text(str.substring(0,dotIndex));
	        }).css("display", "block");

        	$("#tag option").each(function() {
        		if ($(this).text() === '') {
        			$(this).text('None');
        		}
        	});

        	var artistTimeout, 
        		setLetter = getUrlVars()['artistFilter'];
        		firstCall = setLetter ? true : false;

        	setupArtistDropdown(setLetter);

        	$("#container").mouseenter(function() {
        		if (firstCall) {
        			firstCall = false;
        			return;
        		}
        		$(this).stop();
        		if (artistTimeout) clearTimeout(artistTimeout);
        		artistTimeout = setTimeout(function() {
        			$("#innerContainerMessage").css('display', 'none');
        			if ($("#innerContainer").css('display', 'none')) {
        				$("#innerContainer").fadeIn(250);
        			}
        		}, 200);

        	}).mouseleave(function() {
        		$(this).stop();
        		if (artistTimeout) clearTimeout(artistTimeout);
        		artistTimeout = setTimeout(function() {
        			$("#innerContainer").fadeOut(250, function() {
        				$("#innerContainerMessage").css('display', 'block');
        			});
        		}, 200);	
        	});

        	

        	$(window).resize(resizeDiv);
        	resizeDiv();
	    }

	    function setupArtistDropdown(setLetter) {
	    	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVW".split("");
	    	alphabet.push("X-Z");
	    	alphabet.push("#");
	    	var artistHtml = '<select><option>All</option>';
	        for (var i = 0; i < alphabet.length; i++) {
	        	artistHtml += '<option>' + alphabet[i] + '</option>';
	        }

	        var changeFunction = function(chosen) {
        		if (chosen === 'All') {
        			$(".artistLetter").css("display", 'block');
        		}
        		else {
        			artistDropdown = chosen;
        			$(".artistLetter").css("display", 'none');
        			$(document.getElementById("artistLetter" + chosen)).css("display", "block");
        		}
        	}

	    	$("#artistDropdown").html(artistHtml + '</select>').change(function() {
	    		changeFunction($('option:selected', this).text());
	    	});

        	$("#artistDropdown select").width($("#artistDropdown select").width() + 10);

        	if (setLetter) {
        		$("#innerContainerMessage").css('display', 'none');
        		$("#innerContainer").css('display', 'block');
        		$("#artistDropdown option").each(function() {
		    		if ($(this).text() === setLetter) {
		    			$(this).prop('selected', true);
		    			changeFunction(setLetter);

		    		}
		    	});
        	}

	    }

	    function getUrlVars() {
		    var vars = {};
		    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
		        vars[key] = value;
		    });
		    return vars;
		}


	    function resizeDiv() {
	    	var heightDiff = $("#container").height() - $("#innerContainerTop").height();
        	$("#innerDivWrapper").height(heightDiff -20);
	    }
	</script>
	
	<meta http-equiv="Pragma" content="no-cache">
	
</head>
	
<body class="bgcolor2 leftframe" onload="init()" style="margin-top:15px;">
<div id="container">
	<div id="innerContainerTop">
		<a name="top"></a>

		<!-- <div style="padding-bottom:0.5em">
			<c:forEach items="${model.indexes}" var="index">
				<a href="#${index.key}" accesskey="${index.key}">${index.key}</a>
			</c:forEach>
		</div> -->

		<!-- <c:if test="${not empty model.statistics}">
			<div class="detail">
				<fmt:message key="left.statistics">
					<fmt:param value="${model.statistics.artistCount}"/>
					<fmt:param value="${model.statistics.albumCount}"/>
					<fmt:param value="${model.statistics.trackCount}"/>
					<fmt:param value="${model.statisticsBytes}"/>
					<fmt:param value="${model.statistics.totalLengthInHours}"/>
				</fmt:message>
			</div>
		</c:if> -->

		<c:if test="${not empty model.playlists}">
			<div class="leftHeader"><span>Playlists</span></div>
		</c:if>

		<c:choose>
		    <c:when test="${not model.playlistDirectoryExists}">
		        <p class="warning">Bro... set your playlist directory in settings to a folder that exists.</p>
		    </c:when>
		    <c:when test="${empty model.playlists}">
		    	<p class="warning">No playlists.</p>
		    </c:when>
		    <c:otherwise>
		        <c:forEach items="${model.playlists}" var="playlist">
		        	<sub:url value="viewPlaylist.view" var="viewUrl"><sub:param name="name" value="${playlist}"/></sub:url>
		        	<a target='main' class="playlistName" href="${viewUrl}" style="display:none">${playlist}</a>
		        </c:forEach>
		    </c:otherwise>
		</c:choose>
			
		<div style="height:30px"></div>
		<div class="leftHeader"><span style="margin-top:5px">Filters</span></div>
		<div id="artistFilterDiv">
			<span class="leftFilter">Artist</span><br />
			<div id="artistDropdown"></div>
		</div>	
<!-- 		<div class="bgcolor2">
			<c:forEach items="${model.indexes}" var="index">
				<a href="#${index.key}" accesskey="${index.key}">${index.key}</a>
			</c:forEach>
		</div> -->
		<span class="leftFilter" id="genreFilter">Genre</span><br/>

		<c:if test="${not empty model.tags}">
			<select id="tag">
			<c:forEach items="${model.tags}" var="tag">
		        <sub:url value="left.view" var="leftUrl"><sub:param name="tag" value="${tag}"/></sub:url>
				<option value="${leftUrl}"<c:if test="${tag eq model.currentTag}"> selected</c:if>>${fn:escapeXml(tag)}</option>
			</c:forEach>
			</select>
	<!-- 		<c:if test="${not empty model.currentTag}">
				<br><a href="javascript:noop()" onclick="javascript:top.playlist.onPlayGenreRadio(new Array('${model.currentTag}'))">Play ${model.currentTag} radio</a>
			</c:if> -->
		</c:if>
	</div>
	<div id="innerDivWrapper">
		<span id="innerContainerMessage">Hover to display artists</span>
		<div id="innerContainer" class="bgcolor2" style="display: none">

			<c:forEach items="${model.indexes}" var="index">
				<div id="artistLetter${index.key}" class="artistLetter">
					<table class="bgcolor1" style="width:100%;padding:0;margin:1em 0 0 0;border:0">
						<tr style="padding:0;margin:0;border:0">
							<th style="text-align:left;padding:0;margin:0;border:0"><a name="${index.key}"></a>
								<h4 style="padding:0;margin:0;border:0"><c:if test="${model.reluctantArtistLoading}"><a href="left.view?indexLetter=${fn:replace(index.key,'#','0')}"></c:if>${index.key}<c:if test="${model.reluctantArtistLoading}"></a></c:if></h4>
							</th>
<!-- 							<th style="text-align:right;">
								<a class="uplink" href="javascript:noop()"><img src="<spring:theme code="upImage"/>" alt=""></a>
							</th> -->
						</tr>
					</table>
					<div class="artistLinks">
						<c:forEach items="${index.value}" var="artist">
							<p class="dense">
								<span title="${fn:escapeXml(artist.name)}">
									<sub:url value="artist.view" var="artistUrl"><sub:param name="id" value="${artist.id}"/></sub:url>
									<a target="main" href="${artistUrl}">${fn:escapeXml(artist.name)}</a>
								</span>
							</p>
						</c:forEach>
					</div>
				</div>
			</c:forEach>
			<a name="bottom"></a>
			<div style="height:2em"></div>
		</div>
	</div>

	<c:if test="${not empty model.variousArtistsAlbums}">
		<h2 class="bgcolor1">Various Artists</h2>
		<c:forEach items="${model.variousArtistsAlbums}" var="album">
			<p class="dense" style="padding-left:0.5em">
				<sub:url value="artist.view" var="albumUrl"><sub:param name="id" value="${album.artist.id}"/><sub:param name="albumId" value="${album.id}"/></sub:url>
				<a target="main" href="${albumUrl}">${album.name}</a>
			</p>
		</c:forEach>
	</c:if>

	<c:if test="${not empty model.mediaFolders}">
		<h2 class="bgcolor1">Media folders</h2>
		<c:forEach items="${model.mediaFolders}" var="mediaFolder">
			<p class="dense" style="padding-left:0.5em">
				<sub:url value="main.view" var="mainUrl"><sub:param name="path" value="${mediaFolder.path}"/></sub:url>
				<a target="main" href="${mainUrl}">${mediaFolder.name}</a>
			</p>
		</c:forEach>
	</c:if>

	<!-- <c:if test="${empty model.filebased}">
		<div style="height:2em"></div><hr>
		<c:if test="${model.uploadRole}"><a target="main" href="more.view">Upload new music</a><br></c:if>
		<c:if test="${model.adminRole}"><a target="main" href="missingAlbums.view">Missing albums</a><br></c:if>
		<a href="left.view?method=file">File-based browsing</a>
	</c:if> -->

	<!-- <div style="height:5em"></div>

	<div class="bgcolor2" style="opacity: 1.0; clear: both; position: fixed; bottom: 0; right: 0; left: 0;
		  padding: 0.25em 0.75em 0.25em 0.75em; border-top:1px solid black; max-width: 850px;">
		<c:forEach items="${model.indexes}" var="index">
			<a href="#${index.key}" accesskey="${index.key}">${index.key}</a>
		</c:forEach>
	</div> -->

	<c:if test="${not empty model.reluctantArtistLoading and not empty model.indexedLetter}">
	<script type="text/javascript">
	window.location.hash='${fn:replace(model.indexedLetter,'#','#bottom')}';
	</script>
	</c:if>

	<div id="artistPopup" style="display:none;"></div>
	<div style="height:20em"></div>
</div>
</body></html>