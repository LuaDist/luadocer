$(document).ready(function() {
	$('.pretty_printer .while, .pretty_printer .globalfunction, .pretty_printer .localfunction, .pretty_printer .function, .pretty_printer .if, .pretty_printer .upper_elseif, .pretty_printer .upper_else, .pretty_printer .do, .pretty_printer .while, .pretty_printer .repeat, .pretty_printer .numericfor, .pretty_printer .genericfor').each(function(index,value) {
		var el=document.createElement("a");
		if(el)
		{
			el.href="#";
			el.onclick=function() {
				var elm=document.createElement("span");
				
				if(elm)
				{
					elm.innerHTML=" ... ";
					elm.className="pp_js_etc";
				}
				
				if($(this).next().hasClass("upper_elseif") || $(this).next().hasClass("upper_else"))
				{
					var obj=this;
					var prot=0;
					var elm;
					
					while(!$(obj).hasClass("block") && prot<256)
					{
						obj=$(obj).next();
						if($(obj).prev().hasClass("pp_js_etc"))
							$(obj).prev().remove();
						prot++;
					}
					$(obj).toggle();
					if(!$(obj).is(":visible"))
					{
						var res=search_for_newline(obj);
						if(res[0])
						{
							elm.innerHTML+=res[1];
						}
						$(obj).before(elm).before($('.upper_ignored:last-child',obj).text().match(/\n+$/));
					}
					
				}
				else
				{
					$('.block:eq(0)',$(this).next()).toggle();
					if($('.block:eq(0)',$(this).next()).is(":visible"))
						$('> .pp_js_etc:eq(0), > * > .pp_js_etc:eq(0)',$(this).next()).remove();
					else
					{
						var res=search_for_newline($('.block:eq(0)',$(this).next()));
						if(res[0])
						{
							elm.innerHTML+=res[1];
						}
						$('.block:eq(0)',$(this).next()).before(elm);
					}
				}
				if(this.innerHTML=="[+]")
				{
					this.innerHTML="[-]";
					this.className="toggler toggler_expanded";
				}
				else
				{
					this.innerHTML="[+]";
					this.className="toggler toggler_collapsed";
				}
				return false;
			};
			el.innerHTML="[-]";
			el.className="toggler toggler_expanded";
			value.parentNode.insertBefore(el,value);
		}
	});
	$('.pretty_printer pre').after(function(index) {
		return "<div style='margin-bottom:10px;'><a href='#' onclick='return pp_expand($(this).parent().parent());'>Expand all</a> | <a href='#' onclick='return pp_collapse($(this).parent().parent());'>Collapse all</a> | <a href='#' onclick='return pp_toggle($(this).parent().parent(),"+index+");'>Show / hide togglers</a></div>";
	});
	$('.pretty_printer pre .pp_js_varid').hover(function(ev) {
		var id=this.className.match(/pp_js_var([0-9]+)/);
		if(id)
		{
			var prot=0;
			obj=this;
			while(obj.tagName.toLowerCase()!="pre" && prot<256) //highlight only for this instance of pretty printer
			{
				obj=obj.parentNode;
				prot++;
			}
			$('.pp_js_var'+id[1],obj).addClass('pp_js_var_highlight');
		}
	}, function(ev) {
		var id=this.className.match(/pp_js_var([0-9]+)/);
		if(id)
			$('.pretty_printer pre .pp_js_var'+id[1]).removeClass('pp_js_var_highlight'); //remove all highlighted instances from all prettyprinters
	});
});

function search_for_newline(obj)
{
	var preserve_newline=false;
	var space_concat="";
	$('.upper_ignored',obj).each(function(index,value) {
		if(!$(this).next().length || $(this).next().hasClass('upper_ignored'))
		{
			$('*',this).each(function(index,value) {
				if($(this).text().match(/\n+$/))
				{
					preserve_newline=true;
					space_concat=$(this).text().match(/\n+$/);
				}
				else
					space_concat+=$(this).text();
			});
		}
		else
			preserve_newline=false;
	});
	return new Array(preserve_newline,space_concat);
}

function pp_expand(obj)
{
	//toto funguje lahko, rozbaluje sa od hora
	$('a.toggler_collapsed',obj).click();
	return false;
}

function pp_collapse(obj)
{
	//nodes treba zabalovat z najvacsich hlbok
	
	//kedze nie je mozne zabalit rozbalenu node, ktora je vo vnutri ZABALENEHO parent uzla, najprv zavolame pp_expand() a
	//mame tak zarucene, ze vsetky nodes su viditelne -> vsetky nodes mozeme zabalit bez vynimky, aj ked ich pouzivatel pred tym zabalil manualne
	pp_expand(obj);
	
	var objs=new Array();
	
	var obj=$('a.toggler_expanded',obj).each(function(index,value) {
		var prot=0;
		var obj=this;
		var level=0;
		
		while(!$(obj).parent().hasClass("pretty_printer") && prot<256)
		{
			level++;
			prot++;
			obj=$(obj).parent();
		}
		
		if(objs[level]==null)
			objs[level]=new Array(value);
		else
			objs[level].push(value);
	});
	
	if(objs.length)
	{
		for(i=objs.length-1;i>=0;i--)
		{
			if(objs[i])
			{
				for(x=0;x<objs[i].length;x++)
				{
					$(objs[i][x]).click();
				}
			}
		}
	}
	
	return false;
}

var pp_toggle_state=new Array();
function pp_toggle(obj,index)
{
	//jednoduchy toggle nestaci, kedze pri zabalenej node su jej sub-togglers vyhodnotene ako not :visible, teda toggle ich zviditelni
	if(pp_toggle_state[index])
		$('a.toggler',obj).show();
	else
		$('a.toggler',obj).hide();
	pp_toggle_state[index]=!pp_toggle_state[index];
	return false;
}

