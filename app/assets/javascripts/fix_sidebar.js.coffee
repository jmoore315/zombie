#fix_sidebar
@fix_sidebar = ->
	sidebar = '.rentals_sidebar'
	theLoc = $(sidebar).position().top - 15
	$(window).scroll(
		() ->
			if theLoc >= $(window).scrollTop()
				if $(sidebar).hasClass('fixed')
					$(sidebar).removeClass('fixed')
			else
				if !$(sidebar).hasClass('fixed')
					$(sidebar).addClass('fixed')
	)