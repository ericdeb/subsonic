<div id="homeWrapper" class="mainframe bgcolor1" onload="homeInit()">

    <%@ include file="toggleStar.jspf" %>

    <div id="scrollWrapper">

        <div id="scrollContainer">
    <!-- 
            <h1>
                <img src="<spring:theme code="homeImage"/>" alt="">
                ${model.welcomeTitle}
            </h1>

            <c:if test="${not empty model.welcomeSubtitle}">
                <h2>${model.welcomeSubtitle}</h2>
            </c:if> -->

            <c:if test="${model.admin}">
                <c:if test="${model.isIndexBeingCreated}">
                    <p class="warning"><fmt:message key="home.scan"/></p>
                </c:if>

                <c:if test="${empty model.lastFmUser}">
                    <div>
                        <span style="color: red">
                            Last.fm scrobbling not configured! For full statistics and personal music recommendations, <a href="lastFmSettings.view">click here</a>.
                        </span>
                    </div>
                </c:if>
            </c:if>

            <div id="topLinks">
                <c:forTokens items="newest recent frequent topartists random recommended" delims=" " var="cat" varStatus="loopStatus">
                    <c:if test="${loopStatus.count > 1}"><span class="bigLine">&nbsp;|&nbsp;</span></c:if>
                    <sub:url var="url" value="home.view">
                        <sub:param name="listType" value="${cat}"/>
                    </sub:url>

                    <c:choose>
                        <c:when test="${model.listType eq cat}">
                            <span class="headerSelected"><fmt:message key="home.${cat}.title"/></span>
                        </c:when>
                        <c:otherwise>
                            <a href="${url}"><fmt:message key="home.${cat}.title"/></a>
                        </c:otherwise>
                    </c:choose>

                </c:forTokens>
            </div>

            <c:if test="${not model.listType eq 'topartists'}"><h2><fmt:message key="home.${model.listType}.text"/></h2></c:if>

            <table width="100%">
                <tr>
                    <td style="vertical-align:top;">


                        <c:if test="${model.listType eq 'newest'}"><%@ include file="homeQuery.jspf" %><%@ include file="homeAlbums.jspf" %></c:if>
                        <c:if test="${model.listType eq 'recent' or model.listType eq 'frequent' or model.listType eq 'starred' or model.listType eq 'random'}">
                        	<%@ include file="homeArtistAlbumSongMenu.jspf" %>
                        </c:if>
                        <c:if test="${model.listType eq 'topartists'}"><%@ include file="homeTopArtists.jspf" %></c:if>
                        <c:if test="${model.listType eq 'recommended'}"><%@ include file="homeArtists.jspf" %><%@ include file="artistRecommendation.jspf" %></c:if>

                    </td>
    <!--                 <c:if test="${not empty model.welcomeMessage}">
                        <td style="vertical-align:top;width:20em">
                            <div style="padding:0 1em 0 1em;border-left:1px solid #<spring:theme code="detailColor"/>">
                                <sub:wiki text="${model.welcomeMessage}"/>
                            </div>
                        </td>
                    </c:if> -->
                </tr>
            </table>
        </div>
    </div>
</div>
