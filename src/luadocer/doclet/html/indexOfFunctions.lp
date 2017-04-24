<% luadoc.doclet.html.include("header.lp", {title="List of functions", doc=doc, file_doc={name="dummy"}, location={{"List of functions","index.html"}}, extra_javascript= {'jquery-ui.min.js'}, extra_css= {'jquery-ui-1.8.11.custom.css','indexOfFunctions.css'} }) %>

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

<h1>List of functions</h1>
<p>Indexed list of all functions in the files.</p>

	<form id="myform">
		<input type="checkbox" class="myCheckbox" />
			Show table-field functions and anonymous functions.
	</form>

<h2>Functions</h2>
<%=functionList%>

<h2>Documented functions</h2>
<%=docFunctionList%>

<h2>NOT documented functions</h2>
<%=nDocFunctionList%>


<% luadoc.doclet.html.include("footer.lp", {doc=doc}) %>
