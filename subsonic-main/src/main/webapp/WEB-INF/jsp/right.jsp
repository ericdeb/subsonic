<div class="bgcolor1 rightframe" style="padding-top:2em" onload="rightInit()">

    <c:if test="${model.showNowPlaying}">

        <!-- This script uses AJAX to periodically retrieve what all users are playing. -->
        <script type="text/javascript" language="javascript">

            
        </script>

        <div id="nowPlaying">
        </div>

    </c:if>

    <c:if test="${model.showChat}">
        <h2><fmt:message key="main.chat"/></h2>
        <div style="padding-top:0.3em;padding-bottom:0.3em">
            <input id="message" value=" <fmt:message key="main.message"/>" style="width:90%" onclick="dwr.util.setValue('message', null);" onkeypress="dwr.util.onReturn(event, addMessage)"/>
        </div>

        <table>
            <tbody id="chatlog">
            <tr id="pattern" style="display:none;margin:0;padding:0 0 0.15em 0;border:0"><td>
                <span id="user" class="detail" style="font-weight:bold"></span>&nbsp;<span id="date" class="detail"></span> <span id="content"></span></td>
            </tr>
            </tbody>
        </table>

        <c:if test="${model.user.adminRole}">
            <div id="clearDiv" style="display:none;" class="forward"><a href="#" onclick="clearMessages(); return false;"> <fmt:message key="main.clearchat"/></a></div>
        </c:if>
    </c:if>

</div>
