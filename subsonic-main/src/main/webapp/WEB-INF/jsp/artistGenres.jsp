<div id="artistGenres" class="mainframe bgcolor1" onload="artistGenresinit()">

<%@ include file="toggleStar.jspf" %>

<!--
<script type="text/javascript" language="javascript">


	$(document).ready(function() {

		<c:forEach items="${model.topTags}" var="tag">
			add("${tag.name}", ${tag.count} - (${tag.count} % 5));
		</c:forEach>
		
		$("#add").click(function() {
			if ($("#genres option").length > 0) {
				add($("#genres").val(), 50);
				$(this).parent().find("option:selected").remove();
			}
		});
	});

</script>
-->

<div style="padding: 15px;">

<h1>
<a href="#" onclick="toggleStar('art', ${model.artistId}, '#starImage${model.artistId}'); return false;">
	<c:choose>
		<c:when test="${model.artistStarred}">
			<img id="starImage${model.artistId}" src="<spring:theme code="ratingOnImage"/>" alt="">
		</c:when>
		<c:otherwise>
			<img id="starImage${model.artistId}" src="<spring:theme code="ratingOffImage"/>" alt="">
		</c:otherwise>
	</c:choose>
</a>
${model.artistName}
</h1>

<c:if test="${not empty model.artistInfo}">
	<table>
		<tr>
			<td style="vertical-align:top">
				<div class="outerpair1"><div class="outerpair2"><div class="shadowbox"><div class="innerbox">
					<img id="bioArt" width="${model.artistInfoImageSize}" height="${model.artistInfoImageSize}" src="${model.artistInfo.largeImageUrl}" alt="">
				</div></div></div></div>
			</td>
			<td style="vertical-align:top">
				<div style="width:525px;">
					<div id="bio0">${model.artistInfo.bioSummary}</div>
				</div>
			</td>
		</tr>
	</table>
</c:if>

<div id="inp" style="padding-top: 15px; padding-bottom: 25px"></div>

<div style="padding-bottom: 25px">
	<img id="add" src="<spring:theme code="plusImage"/>" alt="Add">
	<select id="genres">
		<c:forEach items="${model.tags}" var="tag">
			<option>${tag}</option>
		</c:forEach>
	</select>
</div>

<sub:url value="artist.view" var="backUrl">
	<sub:param name="id" value="${model.artistId}"/>
</sub:url>
<div class="back"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>

</div>
