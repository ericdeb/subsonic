<div class="mainframe bgcolor1">
    <h1><fmt:message key="changecoverart.title"/></h1>
    <form action="javascript:search()">
        <table class="indent"><tr>
            <td><input id="query" name="query" size="70" type="text" value='"${model.artist}" "${model.album}"'/></td>
            <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="changecoverart.search"/>"/></td>
        </tr></table>
    </form>

    <form action="javascript:setImage(dwr.util.getValue('url'))">
        <table><tr>
            <input id="id" type="hidden" name="id" value="${model.id}"/>
            <td><label for="url"><fmt:message key="changecoverart.address"/></label></td>
            <td style="padding-left:0.5em"><input type="text" name="url" size="50" id="url" value="http://"/></td>
            <td style="padding-left:0.5em"><input type="submit" value="<fmt:message key="common.ok"/>"></td>
        </tr></table>
    </form>
    <sub:url value="artist.view" var="backUrl">
    	<sub:param name="id" value="${model.artistId}"/>
    	<sub:param name="albumId" value="${model.albumId}"/>
    </sub:url>
    <div style="padding-top:0.5em;padding-bottom:0.5em">
        <div class="back"><a href="${backUrl}"><fmt:message key="common.back"/></a></div>
    </div>

    <h2 id="wait" style="display:none"><fmt:message key="changecoverart.wait"/></h2>
    <h2 id="noImagesFound" style="display:none"><fmt:message key="changecoverart.noimagesfound"/></h2>
    <h2 id="success" style="display:none"><fmt:message key="changecoverart.success"/></h2>
    <h2 id="error" style="display:none"><fmt:message key="changecoverart.error"/></h2>
    <div id="errorDetails" class="warning" style="display:none">
    </div>

    <div id="result">

        <div id="pages" style="float:left;padding-left:0.5em;padding-top:0.5em">
        </div>

        <div id="branding" style="float:right;padding-right:1em;padding-top:0.5em">
        </div>

        <div style="clear:both;">
        </div>

        <div id="images" style="width:100%;padding-bottom:2em">
        </div>

        <div style="clear:both;">
        </div>

    </div>

    <div id="template" style="float:left; height:190px; width:220px;padding:0.5em;position:relative">
        <div style="position:absolute;bottom:0">
            <a class="search-result-link"><img class="search-result-thumbnail" style="padding:1px; border:1px solid #021a40; background-color:white;"></a>
            <div class="search-result-title"></div>
            <div class="search-result-dimension detail"></div>
            <div class="search-result-url detail"></div>
        </div>
    </div>

</div>