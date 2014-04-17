module ApplicationHelper

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder)
		end
	    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

	def schools
		School.select(:name, :code).where(active: true).order(:name).map {|school| [school.name,school.code]}
	end

    def school_links
        School.where(active: true).order(:name).map {|school| [school.name,"http://#{request.host}/#{school.code}"]}
    end

    def school_code_list
        School.where(active: true).order(:name).pluck(:code)
    end

	def property_types
	    [['Rentals','rentals'],['Sublets','sublets'],['Campus Location','campus']]
	end

    # def categories
    #     MarketplaceCategory.uniq.order(:category).pluck(:category)
    # end

    def noimages_thumb
        "https://s3.amazonaws.com/uhoused-admin/images/nopics_thumb.png"
    end

    def noimages_large
        "https://s3.amazonaws.com/uhoused-admin/images/nopics_large.png"
    end

    def no_image_available_thumb
        "https://s3.amazonaws.com/uhoused-admin/images/no_image_available.svg"
    end

    def no_image_available_large
        return { url: "https://s3.amazonaws.com/uhoused-admin/images/no_image_available.svg", width: '200', height: '300' }
    end

	def states
        [["Alabama","AL"],
        ["Alaska","AK"],
        ["Arizona","AZ"],
        ["Arkansas","AR"],
        ["California","CA"],
        ["Colorado","CO"],
        ["Connecticut","CT"],
        ["Delaware","DE"],
        ["Florida","FL"],
        ["Georgia","GA"],
        ["Hawaii","HI"],
        ["Idaho","ID"],
        ["Illinois","IL"],
        ["Indiana","IN"],
        ["Iowa","IA"],
        ["Kansas","KS"],
        ["Kentucky","KY"],
        ["Louisiana","LA"],
        ["Maine","ME"],
        ["Maryland","MD"],
        ["Massachusetts","MA"],
        ["Michigan","MI"],
        ["Minnesota","MN"],
        ["Mississippi","MS"],
        ["Missouri","MO"],
        ["Montana","MT"],
        ["Nebraska","NE"],
        ["Nevada","NV"],
        ["New Hampshire","NH"],
        ["New Jersey","NJ"],
        ["New Mexico","NM"],
        ["New York","NY"],
        ["North Carolina","NC"],
        ["North Dakota","ND"],
        ["Ohio","OH"],
        ["Oklahoma","OK"],
        ["Oregon","OR"],
        ["Pennsylvania","PA"],
        ["Rhode Island","RI"],
        ["South Carolina","SC"],
        ["South Dakota","SD"],
        ["Tennessee","TN"],
        ["Texas","TX"],
        ["Utah","UT"],
        ["Vermont","VT"],
        ["Virginia","VA"],
        ["Washington","WA"],
        ["West Virginia","WV"],
        ["Wisconsin","WI"],
        ["Wyoming","WY"]]
	end
end
