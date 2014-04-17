@render_contact_email = (cssid) ->
	username = "contact"
	hostname = "uhoused.com"
	linktext = username + "@" + hostname
	element = document.getElementById(cssid)
	element.innerHTML = "<a href='" + "mail" + "to:" + username + "@" + hostname + "'>" + linktext + "</a>";
