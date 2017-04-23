<% luadoc.doclet.html.include("header.lp", {title="Info comments", doc=doc, file_doc={name="dummy"}, location={{"Info comments","custom.html"}}, extra_javascript= {'jquery-ui.min.js'}, extra_css= {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'} }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
		});
	</script>


<h1>Informational comments</h1>

<div id="tabs">
	<ul>
		<li><a href="#tab1">What TODO?</a></li>
		<li><a href="#tab2">Here are BUGs:</a></li>
		<li><a href="#tab3">Some questions:</a></li>
		<li><a href="#tab4">Fix me please!</a></li>
		<li><a href="#tab5">Infos:</a></li>
		<li><a href="#tab6">How:</a></li>
	</ul>
	<div id="tab1">
		<%=todoComments%>
	</div>
	<div id="tab2">
		<%=bugComments%>
	</div>
	<div id="tab3">
		<%=questionComments%>
	</div>
	<div id="tab4">
		<%=fixmeComments%>
	</div>
	<div id="tab5">
			<%=infoComments%>
	</div>
	<div id="tab6">
			<%=howComments%>
	</div>
</div>

<%= luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
