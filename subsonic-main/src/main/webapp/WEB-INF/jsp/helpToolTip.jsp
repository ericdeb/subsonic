<%@ include file="include.jspf" %>

<%--
  Shows online help as a balloon tool tip.

PARAMETERS
  topic: Refers to a key in the resource bundle containing the text to display in the tool tip.
--%>

<spring:theme code="helpPopupImage" var="imageUrl"/>
<fmt:message key="common.help" var="help"/>

<div style="display:none">
    <div id="placeholderTitle-${param.topic}"><fmt:message key="helppopup.${param.topic}.title"><fmt:param value="Subsonic"/></fmt:message></div>
    <div id="placeholderText-${param.topic}"><fmt:message key="helppopup.${param.topic}.text"><fmt:param value="Subsonic"/></fmt:message></div>
</div>
<img id="toolTipImage-${param.topic}" src="${imageUrl}" alt="${help}" title="${help}" onload="setupToolTip('${param.topic}')"/>
