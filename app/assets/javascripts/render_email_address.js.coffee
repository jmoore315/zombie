@render_email_address = (cssclass, user) ->
	username = user
	hostname = "uhoused.com"
	linktext = username + "@" + hostname
	emails = document.getElementsByClassName(cssclass);
	for element in emails by 1
		element.innerHTML = "<a href='" + "mail" + "to:" + username + "@" + hostname + "'>" + linktext + "</a>";