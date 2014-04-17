##
# InfoController renders all pages containing informational content - the home page,
# about pages, help contact pages, etc.
#
class InfoController < ApplicationController
	skip_before_filter :show_navbar_search, only: :home

	private 
		def info_section_true
			@info_section = true
		end

	public 

		before_filter :info_section_true, except: :home

		def home
			if user_signed_in?
				if @current_account.role == 'landlord'
					redirect_to listings_url
				elsif @current_account.role == 'student'
					redirect_to school_home_url(school_code: @current_account.code)
				elsif @current_account.role == 'school_admin'
					redirect_to school_admin_url(school_code: @current_account.code)
				end
			end
		end



		##
		# "What We Do" pages
		# 

		def faq
			@partial = params[:question]
			@title = params[:title]
		end


		##
		# How it works pages
		#

		def info_landlords
			@info_section_name = 'landlords'
		end

		def info_schools
			@info_section_name = 'schools'
		end

		def info_students
			@info_section_name = 'students'
		end

		def info_parents
			@info_section_name = 'parents'
		end

		##
		# "Help" pages
		# 
		def help 
			@info_section_name = 'help'
		end

		def help_walkthroughs
			@info_section_name = 'help_walkthroughs'
		end

		def help_support
			@info_section_name = 'help_support'
		end

		##
		# "About" pages
		# 

		def about_us
			@info_section_name = 'about_us'
		end

		def about_team
			@info_section_name = 'about_team'
		end

		#def about_jobs
		#	@info_section_name = 'about_jobs'
		#end


		def about_contact
			@info_section_name = 'contact'
		end

		##
		# "Legal" pages
		# 
		def legal
			@info_section_name = 'legal'
		end

		def legal_terms
			@info_section_name = 'legal_terms'
		end

		def legal_privacy
			@info_section_name = 'legal_privacy'
		end

		#def legal_housing
		#	@info_section_name = 'legal_housing'
		#end

		#def legal_dmca
		#end

		##
		# View all schools page
		# 
		def list_of_schools
			@schools = School.where(active: true).order(:name)
		end

end