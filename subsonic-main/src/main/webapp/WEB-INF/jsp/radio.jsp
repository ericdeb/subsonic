<div id="radioWrapper" class="mainframe bgcolor1" onload="radioInit()">

    <div id="scrollWrapper" style="max-width:900px">

        <div id="scrollContainer" style="padding-top:40px;">

            <c:choose>
                <c:when test="${empty model.topTags}">
                    <p>Please configure which genres to use <a href="tagSettings.view">here</a>.
                </c:when>
                <c:otherwise>
                    <div style="margin-bottom: 30px">
                        <span style="font-size: 40px; color: #D01073">Choose one or more genres:</span>
                    </div>

                    <c:forEach items="${model.topTags}" var="topTag">
                        <span class="radioBut off">${topTag}</span>
                    </c:forEach>

                    <div style="clear:both"/>

                    <div>
                        <a id="playRadio" onClick="playGenreRadio();" href="javascript:noop()">Play Radio </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>