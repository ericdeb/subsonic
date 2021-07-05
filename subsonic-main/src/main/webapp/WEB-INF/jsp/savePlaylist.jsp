<div class="mainframe bgcolor1">
    <h1><fmt:message key="playlist.save.title"/></h1>
    <form:form commandName="command" method="post" action="savePlaylist.view">
        <table>
            <tr>
                <td>
                    <fmt:message key="playlist.save.name"/>
                </td>

                <td>
                    <form:input path="name" size="30"/>
                </td>

                <td style="padding-left:1em">
                    <fmt:message key="playlist.save.format"/>
                </td>

                <td>
                    <form:select path="suffix">
                        <c:forEach items="${command.formats}" var="format" varStatus="loopStatus">
                            <form:option value="${format}" label="${format}"/>
                        </c:forEach>
                    </form:select>
                </td>

            </tr>
            <tr>
                <td>
                    <input type="submit" value="<fmt:message key="playlist.save.save"/>">
                </td>
            </tr>
            <tr>
                <td colspan="2" class="warning"><form:errors path="name"/></td>
            </tr>
        </table>
    </form:form>
</div>
