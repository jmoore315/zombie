$(document).ready(
	() ->
		# login and signup form callbacks
		$('.dropdown-toggle').dropdown()
		$('.dropdown-menu, .dropdown-menu input, .dropdown-menu label').click (e) ->
        	e.stopPropagation()
		$('.sign_up_link').on 'click', (e) ->
			$('#signup_modal').modal('toggle')

		$('.roommate_link').on 'click', (e) ->
			$('#roommate_account_create_modal').modal('toggle')

		$('#bookmark-non-student').on 'click', (e) ->
			$('#bookmark-non-student-modal').modal('toggle')

		$('#bookmark-no-account').on 'click', (e) ->
			$('#bookmark-no-account-modal').modal('toggle')

		$('#send_button').on 'click', (e) ->
			$('#send_button').button('loading')

		# select2
		$('select.prop_state').select2()
		$('select.signupselect').select2()

		# tabs
		$('#signup_tabs a').click (e) ->
			$(this).tab('show')
			e.preventDefault()

		# datepicker-bootstrap
		$('.date').datepicker({"format": "yyyy-mm-dd"})

		#range slider
		$('#price_slider').slider(
			range: true,
			min: 0,
			max: 10000,
			values: [$('.price_min').text(),$('.price_max').text()],
			step: 200,
			slide: (event, ui) ->
				$('.price_min').text(ui.values[0])
				$('.price_min').val(ui.values[0])
				$('.price_max').text(ui.values[1])
				$('.price_max').val(ui.values[1])
		)

		# daterangepicker
		$('.lease_picker_student').daterangepicker()

		# image carousel
		$('.carousel').carousel('pause')

		# image deletion
		$('.del_img').on 'click', (e) ->
			$(this).parent("li").fadeOut()

		# image uploader
		$("#imageuploader").S3Uploader
			before_add: (file) ->
				if /(\.|\/)(jpe?g|png)$/i.test(file.type)
					true
				else
					alert "You may not upload #{file.name} because it is not a jpg, jpeg, or png image."
					false
		
		# keep track of facebook likes
		# window.fbAsyncInit = ->
		# 	FB.Event.subscribe "edge.create", (response) ->
		# 		id = $(".fb-like").attr("data-id")
		# 		console.log id
		# 		$.ajax
		# 			type:"PUT",
		# 			url:"/property/#{id}"
		# 			data: {"like": true}
	
		# school picker typeahead
		$('.school-picker').typeahead(
			source: ((query,process) ->
				$.ajax(
					url:"/school_list",
					type:"get",
					data:{query: query},
					dataType:"json",
					success: (response) ->
						return process(response)
				)
			),
			minLength: 0,
			updater: (item) ->
				window.location.href = "/choose_school?school=" + item
				return item
		)

		# settings tooltips
		institution = if $('.account_email').hasClass('Company') then "company" else "school"
		$('.account_email').tooltip(
			title: "This email is your #{institution}'s public contact address. Your log-in email address is in User Settings"
		)
		$('.user_email').tooltip(
			title: "This is the email address used for login."
		)

		# settings deactivate modal
		$('.deactivate_link').on 'click', (e) ->
			$('#deactivate_modal').modal('toggle')

		#affix_sidebar

		if $('.rentals_sidebar').position() != undefined
			sidebar = '.rentals_sidebar'
			theLoc = $(sidebar).position().top - 15
			paginationLoc = $('.pagination').offset().top + $('.pagination').height() + 12
			$(window).scroll(
				() ->
					if theLoc >= $(window).scrollTop()
						if $(sidebar).hasClass('fixed')
							$(sidebar).removeClass('fixed')
							$(sidebar).css('margin-top', 0)
					else if paginationLoc - $(sidebar).height() - 10 < $(window).scrollTop()
						if $(sidebar).hasClass('fixed')
							$(sidebar).removeClass('fixed')
							$(sidebar).addClass('sidebar-fixed-up')
							$(sidebar).css('margin-top', paginationLoc - 679)		
					else
						if !$(sidebar).hasClass('fixed')
							if $(sidebar).hasClass('sidebar-fixed-up')
								if paginationLoc - $(sidebar).height() - 30 >= $(window).scrollTop()
									$(sidebar).removeClass('sidebar-fixed-up')
									$(sidebar).css('margin-top', -107)
									$(sidebar).addClass('fixed')
							else if !$(sidebar).hasClass('sidebar-fixed-up')
								$(sidebar).addClass('fixed')
								$(sidebar).css('margin-top', -107)
			)
		$('.faq a').on 'click', (e) ->
			$('#faq_modal').modal('toggle')

		# Remote Form Submission
		$('.remoteform').on 'change', (e) ->
			$(this.form).submit()
			$(".saved").hide()
			$(".saving").fadeIn()
)