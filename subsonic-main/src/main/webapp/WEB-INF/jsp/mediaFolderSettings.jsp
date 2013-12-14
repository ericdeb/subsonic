<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>

<html><head>
    <%@ include file="head.jspf" %>
    <style>

        a:hover, a:hover {
            text-decoration: none;
        }

        h1, h2, h3, span {
            color: #E2E2E2;
        }

        h2 {
            font-size:26px;
            line-height: 20px;
        }

        .leftInput {
            position: relative;
            top: 7px; 
            left: 10px;
        }

        .botCheck {
            position: relative;
            bottom: 1px;
        }

    </style>
    <script>
        function init() {
            $("#missingCount").text($('#missingFiles li span').size());
        }
    </script>
    </head>
<body class="mainframe bgcolor1" onload="init()">

<script type="text/javascript" src="<c:url value="/script/wz_tooltip.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/tip_balloon.js"/>"></script>

<div id="scrollWrapper">

    <div id="scrollContainer">

        <c:import url="settingsHeader.jsp">
            <c:param name="cat" value="mediaFolder"/>
        </c:import>

        <form method="post" action="mediaFolderSettings.view">
        <table class="indent">
            <tr>
                <th><fmt:message key="mediaFoldersettings.name"/></th>
                <th><fmt:message key="mediaFoldersettings.path"/></th>
                <th style="padding-left:1em"><fmt:message key="mediaFoldersettings.indexed"/></th>
                <th style="padding-left:1em"><fmt:message key="common.delete"/></th>
            </tr>

            <c:forEach items="${model.mediaFolders}" var="folder">
                <tr>
                    <td><input type="text" name="name[${folder.id}]" size="20" value="${folder.name}" style="position: relative;
                        top: 7px;"/></td>
                    <td><input type="text" class="leftInput" name="path[${folder.id}]" size="40" value="${folder.path.path}"/></td>
                    <td align="center" style="padding-left:1em"><input type="checkbox" ${folder.indexed ? "checked" : ""} name="indexed[${folder.id}]" class="checkbox"/></td>
                    <td align="center" style="padding-left:1em"><input type="checkbox" name="delete[${folder.id}]" class="checkbox botCheck" <c:if test="${model.indexBeingCreated}">disabled title="Media folders cannot be deleted during library scanning."</c:if>/></td>
                </tr>
            </c:forEach>

            <tr>
                <th colspan="4" align="left" style="padding-top:1em"><div style="margin-bottom:4px"><fmt:message key="mediaFoldersettings.add"/></div></th>
            </tr>

            <tr>
                <td><input type="text" name="name" size="20"/></td>
                <td><input type="text" class="leftInput" name="path" style="top: 0px" size="40"/></td>
                <td align="center" style="padding-left:1em"><input name="indexed" checked type="checkbox" class="checkbox" 
                    style="position: relative; bottom: 5px"/></td>
                <td/>
            </tr>

            <tr>
                <td colspan="4" style="padding-top:1.5em">
                    <input type="submit" class="btn" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
                    <input type="button" class="btn" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'">
                </td>
            </tr>

        </table>
        </form>

        <c:if test="${not empty model.error}">
            <p class="warning"><fmt:message key="${model.error}"/></p>
        </c:if>

        <c:if test="${not model.databaseAvailable}">
        	<p style="padding-top:1em"><b>MusicCabinet configuration</b></p>
        	<p>MusicCabinet configuration isn't completed. Please finish it <a href="musicCabinetSettings.view">here</a> before scanning media folders.</p>
        </c:if>

        <c:if test="${model.databaseAvailable and not model.indexBeingCreated}">
        <div style="padding-top:30px">
        	<h2>Scan media folders</h2>
        		<a href="searchSettings.view?update=offline">Offline scan</a> | 
        		<a href="searchSettings.view?update=normal">Normal scan</a> | 
        		<a href="searchSettings.view?update=full">Full scan</a>
        		<c:import url="helpToolTip.jsp"><c:param name="topic" value="searchsettingsscan"/></c:import>
        </div>
        </c:if>

        <c:if test="${fn:length(model.filesMissingMetadata) > 0}">
        <div id="missingFiles" style="padding-top:30px">
        	<h2>Files lacking tags - <span id="missingCount"></span></h2>
            <div style="height:7px;"></div>
        	<span style="font-size: 18px;">These files lack either artist or track tag, and are ignored by MusicCabinet.</span>
        	<c:import url="helpToolTip.jsp"><c:param name="topic" value="filesmissingmetadata"/></c:import>
            <div style="height:6px;"></div>
        	<ul>
        	<c:forEach items="${model.filesMissingMetadata}" var="file">
        		<li><span>${file}</span></li>
        	</c:forEach>
        	</ul>
        </div>
        </c:if>

        <c:if test="${model.reload}">
            <script type="text/javascript">
                parent.frames.upper.location.href="top.view?";
        		<c:if test="${not model.hasArtists}">
        			parent.frames.left.location.href="left.view?";
        		</c:if>
            </script>
        </c:if>

    </div>
</div>

</body></html>