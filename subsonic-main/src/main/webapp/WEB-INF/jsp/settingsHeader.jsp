<div id="settingsHeaderWrapper" style="max-width:980px; line-height: 30px">
    <c:set var="categories" value="${param.restricted ? 'personal password player share' : 'mediaFolder general advanced personal user player share network transcoding internetRadio podcast search musicCabinet'}"/>

    <span style="font-size:22px;">
    <c:forTokens items="${categories}" delims=" " var="cat" varStatus="loopStatus">
        <c:choose>
            <c:when test="${loopStatus.count > 1 and  (loopStatus.count - 1) % 7 != 0}">&nbsp;|&nbsp;</c:when>
            <c:otherwise></c:otherwise>
        </c:choose>

        <c:url var="url" value="${cat}Settings.view?"/>

        <c:choose>
            <c:when test="${param.cat eq cat}">
                <span class="headerSelected"><fmt:message key="settingsheader.${cat}"/></span>
            </c:when>
            <c:otherwise>
                <a href="${url}"><fmt:message key="settingsheader.${cat}"/></a>
            </c:otherwise>
        </c:choose>

    </c:forTokens>
    </span>
</div>
