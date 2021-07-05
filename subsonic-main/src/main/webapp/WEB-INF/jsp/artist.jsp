<div id="artistWrapper" class="mainframe bgcolor1" onload="artistInit()">

<!--
<script type="text/javascript" language="javascript">

	$(function() {
	    <c:forEach items="${model.albums}" var="album" varStatus="i">
	        <c:if test="${album.selected}">
	            toggleAlbum('${i.count}');
	            window.location.hash='alb${i.count}';
	        </c:if>
	    </c:forEach>
	});
</script>
-->

<%@ include file="albumsHeader.jspf" %>

<%@ include file="toggleStar.jspf" %>

<div id="scrollWrapper">

	<div id="scrollContainer">

		<h1 style="color: #D01073; font-weight:normal">
		${model.artistName}
<!-- 		<a href="#" onclick="toggleStar('art', ${model.artistId}, '#starImage${model.artistId}'); return false;">
			<c:choose>
				<c:when test="${model.artistStarred}">
					<img id="starImage${model.artistId}" src="<spring:theme code="ratingOnImage"/>" alt="">
				</c:when>
				<c:otherwise>
					<img id="starImage${model.artistId}" src="<spring:theme code="ratingOffImage"/>" alt="">
				</c:otherwise>
			</c:choose>
		</a> -->
		</h1>

		<c:if test="${not empty model.artistInfo}">
			<table>
				<tr>
					<td style="vertical-align:top">
						<div style="width:525px;">
							<div id="bio0" <c:if test="${not empty model.artistInfoMinimized}">style="display:none"</c:if>>
								${model.artistInfo.bioSummary}
							</div>
							<div id="bio1" <c:if test="${empty model.artistInfoMinimized}">style="display:none"</c:if>>
								${model.artistInfoFirstSentence}&nbsp;<a href="javascript:noop()" onclick="toggleArtist()">(...)</a>
							</div>
						</div>
						<div id="artistDets" style="line-height: 1.8">
							<c:if test="${model.isInSearchIndex}">
									<sub:url value="related.view" var="relatedUrl"><sub:param name="id" value="${model.artistId}"/></sub:url>
									<a href="${relatedUrl}">Related artists</a><c:if test="${0 < fn:length(model.topTags)}">, </c:if>
							</c:if>
							<c:forEach items="${model.topTags}" var="topTag" varStatus="i">
								<sub:url var="url" value="genres.view">
									<sub:param name="genre" value="${topTag.name}"/>
								</sub:url>
								<a href="${url}">${topTag.name}</a><c:if test="${i.count < fn:length(model.topTags)}">, </c:if>
							</c:forEach>
<!-- 							<c:if test="${fn:length(model.topTags) > 0 and model.allowTopTagsEdit}">
								<a href="artistGenres.view?id=${model.artistId}">&raquo;</a>
							</c:if> -->
						</div>
						<div id="selectDiv">
							<select id="playEnqAdd">
							  <option value="P">Play</option>
							  <option value="E">Enqueue</option>
							  <option value="A">Add Last</option>
							</select>
							<select id="playEnqAddOptions">
							  <option value="all">All</option>
							  <option value="topTracks">Top Tracks</option>
							  <option value="artistRadio">Artist Radio</option>
							  <option value="random">Random</option>
							</select>

							<a id="selectPlayBut" href="javascript:noop()">
								<img width="17" height="17" src="icons/aldebron/artistBut.png">
							</a>
						</div>
					</td>
					<td style="vertical-align:top">
						<div class="outerpair1" style="position:relative; left:100px"><div class="outerpair2"><div class="shadowbox"><div class="innerbox">
							<a href="javascript:noop()" onclick="toggleArtist()">
								<img id="bioArt" width="${model.artistInfoImageSize}" height="${model.artistInfoImageSize}" src="${model.artistInfo.largeImageUrl}" alt="">
							</a>
						</div></div></div></div>
					</td>
				</tr>
			</table>
		</c:if>

		

<!-- 		<h2>

			<a id="all" href="javascript:noop()" onclick="top.playlist.onPlay(${model.trackIds}, playMode());"><fmt:message key="main.playall"/></a> |
			<c:if test="${model.isInSearchIndex}">
				<a id="top_tracks" href="javascript:noop()" onclick="top.playlist.onPlayTopTracks(${model.artistId}, playMode());">Play top tracks</a> |
				<a id="artist_radio" href="javascript:noop()" onclick="top.playlist.onPlayArtistRadio(${model.artistId}, playMode());">Play artist radio</a> |
			</c:if>
			<a id="random" href="javascript:noop()" onclick="top.playlist.onPlayRandom(${model.trackIds}, playMode());"><fmt:message key="main.playrandom"/></a>
			<br/>
			<a id="togglePlayAdd" class="Play" href="javascript:togglePlayAdd()" title="Toggle if new tracks replace the current playlist, are played next, or are appended last to it.">Play/enqueue/add</a>
			<c:if test="${model.isInSearchIndex}">
				<sub:url value="related.view" var="relatedUrl"><sub:param name="id" value="${model.artistId}"/></sub:url>
				| <a href="${relatedUrl}">Related artists</a>
				<sub:url value="artistDetails.view" var="detailsUrl"><sub:param name="id" value="${model.artistId}"/></sub:url>
				| <a href="${detailsUrl}">Details</a>
			</c:if>

			<c:if test="${model.user.coverArtRole and not empty model.artistInfo}">
				<sub:url value="/editArtist.view" var="editArtistUrl"><sub:param name="id" value="${model.artistId}"/><sub:param name="artist" value="${model.artistName}"/></sub:url>
				| <a href="${editArtistUrl}">Edit</a>
			</c:if>
		</h2> -->

		<%@ include file="albums.jspf" %>
	</div>
</div>
