<div id="playerSettings" class="mainframe bgcolor1">

    <div id="scrollWrapper">

        <div id="scrollContainer">

            <c:import url="settingsHeader.jsp">
                <c:param name="cat" value="player"/>
                <c:param name="restricted" value="${not command.admin}"/>
            </c:import>


            <c:choose>
            <c:when test="${empty command.players}">
                <p><fmt:message key="playersettings.noplayers"/></p>
            </c:when>
            <c:otherwise>

            <c:url value="playerSettings.view" var="deleteUrl">
                <c:param name="delete" value="${command.playerId}"/>
            </c:url>
            <c:url value="playerSettings.view" var="cloneUrl">
                <c:param name="clone" value="${command.playerId}"/>
            </c:url>

            <table class="indent">
                <tr>
                    <td><span style="font-weight: bold; font-size: 22px;">Select Player</span></td>
                    <td>
                        <select style="position: relative; left: 7px; top: 5px" name="player" onchange="location='playerSettings.view?id=' + options[selectedIndex].value;">
                            <c:forEach items="${command.players}" var="player">
                                <option ${player.id eq command.playerId ? "selected" : ""}
                                        value="${player.id}">${player.description}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="padding-right:1em"><div class="forward optionLinks"><a href="${deleteUrl}"><fmt:message key="playersettings.forget"/></a></div></td>
                    <td><div class="forward optionLinks"><a href="${cloneUrl}" ><fmt:message key="playersettings.clone"/></a></div></td>
                </tr>
            </table>

            <form:form commandName="command" method="post" action="playerSettings.view">
            <form:hidden path="playerId"/>

            <table class="ruleTable indent" id="playersTable">
                <c:forEach items="${command.technologyHolders}" var="technologyHolder">
                    <c:set var="technologyName">
                        <fmt:message key="playersettings.technology.${fn:toLowerCase(technologyHolder.name)}.title"/>
                    </c:set>

                    <tr>
                        <td class="ruleTableHeader">
                            <form:radiobutton id="radio-${technologyName}" path="technologyName" value="${technologyHolder.name}"/>
                            <b><span for="radio-${technologyName}">${technologyName}</span></b>
                        </td>
                        <td class="ruleTableCell" style="width:40em">
                            <fmt:message key="playersettings.technology.${fn:toLowerCase(technologyHolder.name)}.text"/>
                        </td>
                    </tr>
                </c:forEach>
            </table>


            <table id="playerOptionsTable" class="indent" style="border-spacing:3pt">
                <tr>
                    <td style="font-weight: bold"><fmt:message key="playersettings.type"/></td>
                    <td colspan="3">
                        <c:choose>
                            <c:when test="${empty command.type}">${unknown}</c:when>
                            <c:otherwise>${command.type}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight: bold"><fmt:message key="playersettings.lastseen"/></td>
                    <td colspan="3"><fmt:formatDate value="${command.lastSeen}" type="both" dateStyle="long" timeStyle="medium"/></td>
                </tr>

                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>

                <tr>
                    <td class="leftCol"><fmt:message key="playersettings.name"/></td>
                    <td><form:input path="name" size="16"/><c:import url="helpToolTip.jsp"><c:param name="topic" value="playername"/></c:import></td>
                </tr>

                <tr style="height:50px">
                    <td class="leftCol"><fmt:message key="playersettings.coverartsize"/></td>
                    <td>
                        <form:select path="coverArtSchemeName" cssStyle="width:8em">
                            <c:forEach items="${command.coverArtSchemeHolders}" var="coverArtSchemeHolder">
                                <c:set var="coverArtSchemeName">
                                    <fmt:message key="playersettings.coverart.${fn:toLowerCase(coverArtSchemeHolder.name)}"/>
                                </c:set>
                                <form:option value="${coverArtSchemeHolder.name}" span="${coverArtSchemeName}"/>
                            </c:forEach>
                        </form:select>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="cover"/></c:import>
                    </td>
                </tr>

                <tr style="height:50px">
                    <td class="leftCol"><fmt:message key="playersettings.maxbitrate"/></td>
                    <td>
                        <form:select path="transcodeSchemeName" cssStyle="width:8em">
                            <c:forEach items="${command.transcodeSchemeHolders}" var="transcodeSchemeHolder">
                                <form:option value="${transcodeSchemeHolder.name}" span="${transcodeSchemeHolder.description}"/>
                            </c:forEach>
                        </form:select>
                        <c:import url="helpToolTip.jsp"><c:param name="topic" value="transcode"/></c:import>
                    </td>
                    <td class="warning">
                        <c:if test="${not command.transcodingSupported}">
                            <fmt:message key="playersettings.nolame"/>
                        </c:if>
                    </td>
                </tr>

            </table>

            <table class="indent spanMove" style="border-spacing:3pt">

                <tr>
                    <td>
                        <form:checkbox path="dynamicIp" id="dynamicIp" cssClass="checkbox"/>
                        <span for="dynamicIp"><fmt:message key="playersettings.dynamicip"/></span>
                    </td>
                    <td><c:import url="helpToolTip.jsp"><c:param name="topic" value="dynamicip"/></c:import></td>
                </tr>

                <tr>
                    <td>
                        <form:checkbox path="autoControlEnabled" id="autoControlEnabled" cssClass="checkbox"/>
                        <span for="autoControlEnabled"><fmt:message key="playersettings.autocontrol"/></span>
                    </td>
                    <td><c:import url="helpToolTip.jsp"><c:param name="topic" value="autocontrol"/></c:import></td>
                </tr>
            </table>

                <c:if test="${not empty command.allTranscodings}">
                    <table class="indent spanMove">
                        <tr><td><b><fmt:message key="playersettings.transcodings"/></b></td></tr>
                        <c:forEach items="${command.allTranscodings}" var="transcoding" varStatus="loopStatus">
                            <c:if test="${loopStatus.count % 3 == 1}"><tr></c:if>
                            <td style="padding-right:2em">
                                <form:checkbox path="activeTranscodingIds" id="transcoding${transcoding.id}" value="${transcoding.id}" cssClass="checkbox"/>
                                <span for="transcoding${transcoding.id}">${transcoding.name}</span>
                            </td>
                            <c:if test="${loopStatus.count % 3 == 0 or loopStatus.count eq fn:length(command.allTranscodings)}"></tr></c:if>
                        </c:forEach>
                    </table>
                </c:if>

                <input type="submit" class="btn" value="<fmt:message key="common.save"/>" style="margin-top:1em;margin-right:0.3em">
                <input type="button" class="btn" value="<fmt:message key="common.cancel"/>" style="margin-top:1em" onclick="location.href='nowPlaying.view'">
            </form:form>

            </c:otherwise>
            </c:choose>

            <c:if test="${command.reloadNeeded}">
                <script language="javascript" type="text/javascript">parent.frames.playlist.location.href="playlist.view?"</script>
            </c:if>
        </div>
    </div>
</div>