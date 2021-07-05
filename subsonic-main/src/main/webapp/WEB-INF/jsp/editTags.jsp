<div class="mainframe bgcolor1">

    <h1><fmt:message key="edittags.title"/></h1>
    <sub:url value="artist.view" var="backUrl">
    	<sub:param name="id" value="${model.artistId}"/>
    	<sub:param name="albumId" value="${model.albumId}"/>
    </sub:url>
    <div class="back"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>

    <table class="ruleTable indent">
        <tr>
            <th class="ruleTableHeader"><fmt:message key="edittags.file"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.track"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.songtitle"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.artist"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.albumartist"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.composer"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.album"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.year"/></th>
            <th class="ruleTableHeader"><fmt:message key="edittags.genre"/></th>
            <th class="ruleTableHeader" width="60pt"><fmt:message key="edittags.status"/></th>
        </tr>
        <tr>
            <th class="ruleTableHeader"/>
            <th class="ruleTableHeader"><a href="javascript:suggestTrack()"><fmt:message key="edittags.suggest.short"/></a> |
                <a href="javascript:resetTrack()"><fmt:message key="edittags.reset.short"/></a></th>
            <th class="ruleTableHeader"><a href="javascript:suggestTitle()"><fmt:message key="edittags.suggest"/></a> |
                <a href="javascript:resetTitle()"><fmt:message key="edittags.reset"/></a></th>
            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" name="artistAll" size="15" onkeypress="dwr.util.onReturn(event, setArtist)" value="${model.defaultArtist}"/>&nbsp;<a href="javascript:setArtist()"><fmt:message key="edittags.set"/></a></th>
            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" name="albumArtistAll" size="15" onkeypress="dwr.util.onReturn(event, setAlbumArtist)" value="${model.defaultAlbumArtist}"/>&nbsp;<a href="javascript:setAlbumArtist()"><fmt:message key="edittags.set"/></a></th>
            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" name="composerAll" size="15" onkeypress="dwr.util.onReturn(event, setComposer)" value="${model.defaultComposer}"/>&nbsp;<a href="javascript:setComposer()"><fmt:message key="edittags.set"/></a></th>		
            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" name="albumAll" size="15" onkeypress="dwr.util.onReturn(event, setAlbum)" value="${model.defaultAlbum}"/>&nbsp;<a href="javascript:setAlbum()"><fmt:message key="edittags.set"/></a></th>
            <th class="ruleTableHeader" style="white-space: nowrap"><input type="text" name="yearAll" size="5" onkeypress="dwr.util.onReturn(event, setYear)" value="${model.defaultYear}"/>&nbsp;<a href="javascript:setYear()"><fmt:message key="edittags.set"/></a></th>
            <th class="ruleTableHeader" style="white-space: nowrap">
                <select name="genreAll" style="width:7em">
                    <option value=""/>
                    <c:forEach items="${model.allGenres}" var="genre">
                        <option ${genre eq model.defaultGenre ? "selected" : ""} value="${genre}">${genre}</option>
                    </c:forEach>
                </select>

                <a href="javascript:setGenre()"><fmt:message key="edittags.set"/></a>
            </th>
            <th class="ruleTableHeader"/>
        </tr>

    	<c:forEach items="${model.songs}" var="song" varStatus="loopStatus">
    	<tr>
    	  <td colspan="10" class="ruleTableCell" title="${song.fileName}"><str:truncateNicely lower="25" upper="25" var="fileName">${song.fileName}</str:truncateNicely> ${fileName}</td>
    	  </tr>
    	<tr>
                <str:truncateNicely lower="25" upper="25" var="fileName">${song.fileName}</str:truncateNicely>
                <input type="hidden" name="id${loopStatus.count - 1}" value="${song.id}"/>
                <input type="hidden" name="suggestedTitle${loopStatus.count - 1}" value="${song.suggestedTitle}"/>
                <input type="hidden" name="originalTitle${loopStatus.count - 1}" value="${song.title}"/>
                <input type="hidden" name="suggestedTrack${loopStatus.count - 1}" value="${song.suggestedTrack}"/>
                <input type="hidden" name="originalTrack${loopStatus.count - 1}" value="${song.track}"/>
                <td class="ruleTableCell" title="${song.fileName}">${fileName}</td>
                <td class="ruleTableCell"><input type="text" size="5" name="track${loopStatus.count - 1}" value="${song.track}"/></td>
                <td class="ruleTableCell"><input type="text" size="30" name="title${loopStatus.count - 1}" value="${song.title}"/></td>
                <td class="ruleTableCell"><input type="text" size="15" name="artist${loopStatus.count - 1}" value="${song.artist}"/></td>
                <td class="ruleTableCell"><input type="text" size="15" name="albumArtist${loopStatus.count - 1}" value="${song.albumArtist}"/></td>
                <td class="ruleTableCell"><input type="text" size="15" name="composer${loopStatus.count - 1}" value="${song.composer}"/></td>
                <td class="ruleTableCell"><input type="text" size="15" name="album${loopStatus.count - 1}" value="${song.album}"/></td>
                <td class="ruleTableCell"><input type="text" size="5"  name="year${loopStatus.count - 1}" value="${song.year}"/></td>
                <td class="ruleTableCell"><input type="text" name="genre${loopStatus.count - 1}" value="${song.genre}" style="width:7em"/></td>
                <td class="ruleTableCell"><div id="status${loopStatus.count - 1}"/></td>
    	</tr>
    	</c:forEach>
    	
    </table>

    <p><input type="submit" id="save" value="<fmt:message key="common.save"/>" onclick="javascript:updateTags()"/></p>
    <div class="warning" id="errors"/>
</div>