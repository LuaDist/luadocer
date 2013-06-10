$(function(){

	$('tr.block_comment').hover(function(){
		var css_class = $(this).attr('class');
			css_class = css_class.split(" ");
		var current_block = css_class[css_class.length-1];
		$('tr.'+current_block).addClass('block_highlight');
		$('tr.'+current_block).mouseleave(function(){
			setTimeout($('tr.'+current_block).removeClass('block_highlight'), 500);
		});
	});

	$('tr.block_comment').live("dblclick",function(){
		var css_class = $(this).attr('class');
			css_class = css_class.split(" ");
		var current_block = css_class[css_class.length-1];
		$('tr.'+current_block).fadeToggle();
	});

	$('tr.folder > td:first-child').hover(function(){
		$(this).next().html(
			$(this).parents('tr').next().find('td').first().html()
		);
		$(this).mouseleave(function(){
			$(this).next().html('');
		});
	});

	$('#fullscreen-button').click(function(){
		$('div.literate_doc').appendTo('#literate-fullscreen .scroll-wrapper');
		$('#literate-fullscreen').fadeToggle();
		$('.literate_doc table td.docs').css('min-width', $('.literate_doc').parent().width()/3+'px');
	});

	$('#literate-fullscreen .exit-fullscreen').click(function(){
		$('div.literate_doc').appendTo($('#fullscreen-button').parent());
		$('#literate-fullscreen').fadeToggle();
		$('.literate_doc table td.docs').css('min-width', $('.literate_doc').parent().width()/3+'px');
	});

	$('.lp-toggle-api').click(function(){
		$('.literate_doc tr.api').fadeToggle();
	});

	$('.literate_doc table td.docs').css('min-width', $('.literate_doc').parent().width()/3+'px');

})