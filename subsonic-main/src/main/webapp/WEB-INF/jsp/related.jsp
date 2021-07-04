<div id="relatedWrapper" class="mainframe bgcolor1" onload="relatedInit()">

	<div id="scrollWrapper">

	    <div id="scrollContainer">

			<div style="padding: 15px;">

			<sub:url value="artist.view" var="artistUrl"><sub:param name="id" value="${model.id}"/></sub:url>

			<h1 style="color: #D01073; font-weight:normal">${model.artist}</h1>

			<table>
				<tr>
					<td style="vertical-align:top">
						<div id="artistBio" style="width:525px;">
							${model.artistInfo.bioSummary}
						</div>
					</td>
					<td style="vertical-align:top">
						<div class="outerpair1"><div class="outerpair2"><div class="shadowbox"><div class="innerbox">
							<a href="${artistUrl}">
								<img width="126" height="126" src="${model.artistInfo.largeImageUrl}" alt="">
							</a>
						</div></div></div></div>
					</td>
				</tr>
			</table>

			<br>
			<span id="relatedTitle">Related artists</span>
			<a href="javascript:noop()" onclick="top.playlist.sendPlaylistCommand(P_CMDS.PLAY.RELATED_ARTISTS_SAMPLER, ${model.id}, ${fn:length(model.artists)})">
				<img src="icons/playButBig.png" width="23" height="23" alt="Play related artists sampler" title="Play related artists sampler" style="position: relative; bottom: 5px; left: 2px;">
			</a>
			<div style="height: 10px">
			</div>


			<c:if test="${empty model.artists}"><p>Not a single related artist found!</p></c:if>
			<%@ include file="artists.jspf" %>

			<%@ include file="artistRecommendation.jspf" %>

			</div>
		</div>
	</div>
</div>