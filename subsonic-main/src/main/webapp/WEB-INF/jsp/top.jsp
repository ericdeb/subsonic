<%@ include file="include.jspf" %>

<div class="bgcolor2 topframe" style="margin:0.4em 1em 0.4em 1em; overflow: hidden;">

<fmt:message key="top.home" var="home"/>
<fmt:message key="top.now_playing" var="nowPlaying"/>
<fmt:message key="top.settings" var="settings"/>
<fmt:message key="top.status" var="status"/>
<fmt:message key="top.podcast" var="podcast"/>
<fmt:message key="top.help" var="help"/>

<table style="margin:0"><tr valign="middle">
    <td class="logo" style="padding-right:2em">
        <img src="icons/aldebron/djIcon.png">
    </td>

    <c:if test="${not model.mediaFoldersExist}">
        <td style="padding-right:2em">
            <p class="warning"><fmt:message key="top.missing"/></p>
        </td>
    </c:if>

    <td style="position: absolute; top: 7px; left: 226px;">
        <table><tr align="center">
            <td style="min-width:4em;padding-right:1.5em">
                <a href="playlist.view?" target="main"><img src="<spring:theme code="genresImage"/>" title="Playlist" alt="Playlist"></a><br>
            </td>
            <td style="min-width:4em;padding-right:1.5em">
                <a href="home.view?" target="main"><img src="<spring:theme code="homeImage"/>" title="${home}" alt="${home}"></a><br>
   <!--              <a href="home.view?" target="main">${home}</a> -->
            </td>
	        <td style="min-width:4em;padding-right:1.5em">
	            <a href="genres.view?" target="main"><img src="<spring:theme code="genresImage"/>" title="Genres" alt="Genres"></a><br>
<!-- 	            <a href="genres.view?" target="main">Genres</a> -->
	        </td>
	        <td style="min-width:4em;padding-right:1.5em">
	            <a href="radio.view?" target="main"><img src="<spring:theme code="radioImage"/>" title="Radio" alt="Radio"></a><br>
<!-- 	            <a href="radio.view?" target="main">Radio</a> -->
	        </td>
<!-- 	        <td style="min-width:4em;padding-right:1.5em">
	            <a href="fileTree.view?" target="main"><img src="<spring:theme code="fileTreeImage"/>" title="File tree" alt="File tree"></a><br>
	            <a href="fileTree.view?" target="main">File tree</a>
	        </td> -->
<!--             <td style="min-width:4em;padding-right:1.5em">
                <a href="podcastReceiver.view?" target="main"><img src="<spring:theme code="podcastLargeImage"/>" title="${podcast}" alt="${podcast}"></a><br>
                <a href="podcastReceiver.view?" target="main">${podcast}</a>
            </td> -->
<!--             <td style="min-width:4em;padding-right:1.5em">
                <a href="nowPlaying.view?" target="main"><img src="<spring:theme code="nowPlayingImage"/>" title="${nowPlaying}" alt="${nowPlaying}"></a><br>
                <a href="nowPlaying.view?" target="main">${nowPlaying}</a>
            </td> -->
            <c:if test="${model.user.settingsRole}">
                <td style="min-width:4em;padding-right:1.5em">
                    <a href="settings.view?" target="main"><img src="<spring:theme code="settingsImage"/>" title="${settings}" alt="${settings}"></a><br>
<!--                     <a href="settings.view?" target="main">${settings}</a> -->
                </td>
            </c:if>
            <c:if test="${model.admin}">
                <td style="min-width:4em;padding-right:1.5em">
                    <a href="status.view?" target="main"><img src="<spring:theme code="statusImage"/>" title="${status}" alt="${status}"></a><br>
<!--                     <a href="status.view?" target="main">${status}</a> -->
                </td>
                <td style="min-width:4em;padding-right:1.5em">
                    <a href="help.view?" target="main"><img src="<spring:theme code="helpImage"/>" title="${help}" alt="${help}"></a><br>
<!--                     <a href="help.view?" target="main">${help}</a> -->
                </td>
            </c:if>

            <td style="padding-left:1em">
                <form method="post" action="search.view" target="main" name="searchForm">
                    <table><tr>
                        <td style="position: relative; top: 14px; left: 100px;">
                            <input type="text" name="query" id="query" size="28" placeholder="search">
                        </td>
<!--                         <td><a href="javascript:document.searchForm.submit()"><img src="<spring:theme code="searchImage"/>" alt="${search}" title="${search}"></a></td> -->
                    </tr></table>
                </form>
            </td>
        </tr></table>
    </td>

    <div style="position: absolute; right: 150px; top: 30px; font-size: 30px; cursor:default">
        <span style="position:relative">Welcome ${model.user.username}! </span>
    </div>

    <a href="j_spring_security_logout" target="_top" style="position: absolute; right: 20px; top: 24px;">
        <img src="icons/aldebron/logout.png">
    </a>

</tr></table>
</div>