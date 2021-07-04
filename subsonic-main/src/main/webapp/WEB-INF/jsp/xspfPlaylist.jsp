<%@ include file="include.jspf" %>

<playlist version="0" xmlns="http://xspf.org/ns/0/">
    <trackList>
        <c:forEach var="song" items="${model.songs}">

            <sub:url value="/stream" var="streamUrl">
                <sub:param name="path" value="${song.mediaFile.path}"/>
            </sub:url>

            <sub:url value="coverArt.view" var="coverArtUrl">
                <sub:param name="size" value="200"/>
                <c:if test="${not empty song.coverArtFile}">
                    <sub:param name="path" value="${song.coverArtFile.path}"/>
                </c:if>
            </sub:url>

                <track>
                    <location>${streamUrl}</location>
                    <image>${coverArtUrl}</image>
                    <annotation>${song.mediaFile.metaData.artist} - ${song.mediaFile.title}</annotation>
                </track>

        </c:forEach>
    </trackList>
</playlist>