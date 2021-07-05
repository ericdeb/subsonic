<div id="leftWrapper" class="bgcolor2 leftframe" onload="leftInit()" style="margin-top:15px;">
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
			        <!-- <sub:url value="left.view" var="leftUrl"><sub:param name="tag" value="${tag}"/></sub:url> -->
					<option value="${tag}"<c:if test="${tag eq model.currentTag}"> selected</c:if>>${fn:escapeXml(tag)}</option>
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
</div>