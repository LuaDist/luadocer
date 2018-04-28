//implicitne skrytie vsetkych podmenu
$(document).ready(function() {
	$('.menulist ul').hide();
	//avsak pokial mame aktivne menu, rozbalime jeho strom az po vrch
	var am=$('.menulist .active_menu').each(function(index,value) {
		elm=this;
		while(!$(elm).hasClass('menulist'))
		{
			if(elm.tagName.toLowerCase()=="ul")
			{
				$(elm).show();
			}
			else
			{
				if(elm.tagName.toLowerCase()=="li")
				{
					if(elm.children[0] && elm.children[0].className.toLowerCase()=="toggler")
					{
						//ziadne prepinanie, pretoze chceme mat jednoznacne minus a navyse moze existovat viacero .active_menu pre jeden pageload!
						elm.children[0].innerHTML="[-]";
						//spravime force otvorenia ul, v pripade ze edistuju moduly napr doclet a doclet.children
						$(elm.children[2]).show();
					}
				}
			}
			elm=elm.parentNode;
		}
	});
});

function menu_toggle(obj)
{
	$(obj).next().next().slideToggle();
	if(obj.innerHTML=="[+]")
		obj.innerHTML="[-]";
	else
		obj.innerHTML="[+]";
	return false;
}

function parent_toggle(obj)
{
	$(obj).next().slideToggle();
	if(obj.innerHTML=="[+]")
		obj.innerHTML="[-]";
	else
		obj.innerHTML="[+]";
	return false;
}
