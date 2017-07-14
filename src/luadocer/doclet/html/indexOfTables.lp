<% luadoc.doclet.html.include("header.lp", {title="List of tables", doc=doc, file_doc={name="dummy"}, location={{"List of tables","index.html"}}, extra_javascript =  {'jquery-ui.min.js'}, extra_css = {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'} }) %>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#tabs").tabs();
			$("#tabs2").tabs();
			$("#tabs3").tabs();
			$(".tohide").hide();
			$(".myCheckbox").click(function() {
			    if($(this).is(":checked")) 
				{
					$(".tohide").show();
				}else			
				{
					$(".tohide").hide();
				}
			});
		});
	</script>

<h1>List of tables</h1>
<p>Indexed list of all tables in the files.</p>
<form id="myform">
		<input type="checkbox" class="myCheckbox" />
			Show table-field tables and anonymous tables.
</form>

<h2>Tables</h2>
<%=tableList%>

<h2>Documented tables</h2>
<%=docTableList%>

<h2>NOT documented tables</h2>
<%=nDocTableList%>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
