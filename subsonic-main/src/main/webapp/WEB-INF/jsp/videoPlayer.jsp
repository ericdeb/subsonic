<div class="mainframe bgcolor1" style="padding-bottom:0.5em" onload="videoPlayerInit();">

    <c:set var="backUrl"><%= request.getHeader("referer") %></c:set>
        
    <sub:url value="videoPlayer.view" var="baseUrl"><sub:param name="id" value="${model.video.id}"/></sub:url>

    <sub:url value="/stream" var="streamUrl">
        <sub:param name="mfId" value="${model.video.id}"/>
    </sub:url>

    <c:if test="${not model.popout}">
        <h1>${model.video.title}</h1>
    </c:if>


    <div id="wrapper" style="padding-top:1em">
        <div id="placeholder1"><a href="http://www.adobe.com/go/getflashplayer" target="_blank"><fmt:message key="playlist.getflash"/></a></div>
    </div>

    <div style="padding-top:0.7em;padding-bottom:0.7em">

        <span id="position" style="padding-right:0.5em">0:00</span>
        <select id="timeOffset" onchange="changeTimeOffset();" style="padding-left:0.25em;padding-right:0.25em;margin-right:0.5em">
            <c:forEach items="${model.skipOffsets}" var="skipOffset">
                <c:choose>
                    <c:when test="${skipOffset.value - skipOffset.value mod 60 eq model.timeOffset - model.timeOffset mod 60}">
                        <option selected="selected" value="${skipOffset.value}">${skipOffset.key}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${skipOffset.value}">${skipOffset.key}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>

        <select id="maxBitRate" onchange="changeBitRate();" style="padding-left:0.25em;padding-right:0.25em;margin-right:0.5em">
            <c:forEach items="${model.bitRates}" var="bitRate">
                <c:choose>
                    <c:when test="${bitRate eq model.maxBitRate}">
                        <option selected="selected" value="${bitRate}">${bitRate} Kbps</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${bitRate}">${bitRate} Kbps</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </div>

    <c:choose>
        <c:when test="${model.popout}">
            <div class="back"><a href="javascript:popin();"><fmt:message key="common.back"/></a></div>
        </c:when>
        <c:otherwise>
            <div class="back" style="float:left;padding-right:2em"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>
            <div class="forward" style="float:left;"><a href="javascript:popout();"><fmt:message key="videoPlayer.popout"/></a></div>
        </c:otherwise>
    </c:choose>

</div>
