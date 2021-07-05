<div onLoad="groupSettingsInit">
	<p style="padding-top:1em"><b>Last.fm group subscriptions</b>
		<c:import url="helpToolTip.jsp"><c:param name="topic" value="groupsubscriptions"/></c:import>
	</p>

	<form method="post" action="groupSettings.view">

		<div id="inp"></div>

		<span style="display: block">
			<img id="add" src="<spring:theme code="plusImage"/>" alt="Add">
		</span>
		
		<input id="save" type="button" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
		<input type="button" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'">

	</form>
</div>