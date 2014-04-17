class GAQuery

	def self.basic_query
		key        = "key=AIzaSyAiRkyfv702SOREqoAMx-CB_5Ue3e4GUWg"
		ids        = "ids=ga:UA-39286705-1"
		start_date = "start-date=#{Date.new(2013,1,1).strftime('%Y-%m-%d')}"
		end_date   = "end-date=#{Date.today.strftime('%Y-%m-%d')}"
		metrics    = "metrics=ga:visits"
		getstring = "https://www.googleapis.com/analytics/v3/data/ga?#{ids}&#{key}&#{start_date}&#{end_date}&#{metrics}"
		puts getstring
		response = HTTParty.get(getstring)
	end
end