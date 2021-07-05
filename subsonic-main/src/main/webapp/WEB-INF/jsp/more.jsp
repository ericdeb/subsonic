<div id="moreWrapper" class="mainframe bgcolor1" onload="${model.user.uploadRole ? "refreshProgress()" : ""}">

    <h1>
        <img src="<spring:theme code="moreImage"/>" alt=""/>
        <fmt:message key="more.title"/>
    </h1>

    <c:if test="${model.user.uploadRole}">

        <h2><img src="<spring:theme code="uploadImage"/>" alt=""/>&nbsp;<fmt:message key="more.upload.title"/></h2>

        <form method="post" enctype="multipart/form-data" action="upload.view">
            <table>
                <tr>
                    <td><fmt:message key="more.upload.source"/></td>
                    <td colspan="2"><input type="file" id="file" name="file" size="40"/></td>
                </tr>
                <tr>
                    <td><fmt:message key="more.upload.target"/></td>
                    <td><input type="text" id="dir" name="dir" size="37" value="${model.uploadDirectory}"/></td>
                    <td><input type="submit" value="<fmt:message key="more.upload.ok"/>"/></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="checkbox" checked name="unzip" id="unzip" class="checkbox"/>
                        <label for="unzip"><fmt:message key="more.upload.unzip"/></label>
                    </td>
                </tr>
            </table>
        </form>


        <p class="detail" id="progressText"/>

        <div id="progressBar">
            <div id="progressBarContent"/>
        </div>

    </c:if>

</div>