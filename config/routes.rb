Uhoused2::Application.routes.draw do
  class SchoolConstraint
    def self.matches?(request)
      School.where(active: true).order(:name).pluck(:code).include? request.path_parameters[:school_code]
    end
  end

  class PropertyTypeConstraint
    def self.matches?(request)
      ['rentals','sublets'].include? request.path_parameters[:property_type]
    end
  end

  ##
  # Sidekiq monitoring
  #
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  ##
  # Informational
  #
  get 'info'                     => 'info#info_students',            as: 'info'
  get 'info/students'            => 'info#info_students',            as: 'info_students'
  get 'info/schools'             => 'info#info_schools',             as: 'info_schools'
  get 'info/landlords'           => 'info#info_landlords',           as: 'info_landlords'
  get 'info/parents'             => 'info#info_parents',             as: 'info_parents'

  get '/help'                => 'info#help',                     as: 'help'
  get '/help/walkthroughs'   => 'info#help_walkthroughs',        as: 'help_walkthroughs'
  get '/help/support'        => 'info#help_support',             as: 'help_support'

  get '/about'               => 'info#about_us',                 as: 'about_us'
  get '/team'                => 'info#about_team',               as: 'about_team'
  #get '/jobs'                => 'info#about_jobs',               as: 'about_jobs'
  get '/contact'             => 'info#about_contact',            as: 'about_contact'

  get '/legal'               => 'info#legal',                    as: 'legal'
  get '/legal/terms'         => 'info#legal_terms',              as: 'legal_terms'
  get '/legal/privacy'       => 'info#legal_privacy',            as: 'legal_privacy'

  get '/schools'             => 'info#list_of_schools',          as: 'list_of_schools'
  get '/faq'                 => 'info#faq', as: 'faq'


  ##
  # Image Management
  #
  resources :images

  ##
  # User and Account Management
  #
  devise_for :users, path:'', path_names: {sign_in: 'log_in', sign_out: 'log_out'}, controllers: {registrations: "registrations"}
  get   '/listings'               => 'accounts#listings',               as: 'listings'
  get   '/bookmarks'              => 'accounts#bookmarks',              as: 'bookmarks'
  get   '/settings'               => 'accounts#settings',               as: 'settings'
  get   '/settings/profile'       => 'accounts#settings_profile',       as: 'settings_profile'
  get   '/settings/company'       => 'accounts#settings_company',       as: 'settings_company'
  get   '/settings/user'          => 'accounts#settings_user',          as: 'settings_user'
  get   '/settings/notifications' => 'accounts#settings_notifications', as: 'settings_notifications'
  get   '/settings/billing'       => 'accounts#settings_billing',       as: 'settings_billing'
  get   '/settings/payments'      => 'accounts#settings_payments',      as: 'settings_payments'
  patch '/settings/profile'       => 'accounts#update_settings_profile'
  patch '/settings/company'       => 'accounts#update_settings_company'
  patch '/settings/user'          => 'accounts#update_settings_user'
  patch '/settings/notifications' => 'accounts#update_settings_notifications'
  patch '/settings/billing'       => 'accounts#update_settings_billing'
  patch '/update_email'           => 'accounts#update_email',           as: 'update_email'
  post  '/deactivate_account'     => 'accounts#deactivate',             as: 'deactivate_account'


  ##
  # Property Management (Rental + Sublet)
  #
  get    '/new_rental'     => 'properties#new',         as: 'new_rental'
  get    '/new_sublet'     => 'properties#new',         as: 'new_sublet'
  get    '/property/:id'   => 'properties#show',        as: 'property'
  patch  '/property/:id'   => 'properties#update'
  delete '/property/:id'   => 'properties#delete'
  post   '/unit'           => 'properties#add_unit',    as: 'add_unit'
  delete '/unit/:id'       => 'properties#remove_unit', as: 'remove_unit'
  get    '/activate/:id'   => 'properties#activate',    as: 'activate_property'
  get    '/deactivate/:id' => 'properties#deactivate',  as: 'deactivate_property'

  ##
  # Marketplace Management
  #
  get    '/new_item'            => 'marketplace#new',        as: 'new_item'
  get    '/item/:id'            => 'marketplace#show',       as: 'item'
  patch  '/item/:id'            => 'marketplace#update'
  delete '/item/:id'            => 'marketplace#delete'
  get    '/activate_item/:id'   => 'marketplace#activate',   as: 'activate_item'
  get    '/deactivate_item/:id' => 'marketplace#deactivate', as: 'deactivate_item'
  post   '/change_category/:id' => 'marketplace#category',   as: 'change_item_category'

  ##
  # Roommate Listing Management
  # 
  get    '/new_roommate_profile'        => 'roommate_listings#new',        as: 'new_roommate_listing'
  get    '/roommate_profile'            => 'roommate_listings#show',       as: 'roommate_listing'
  patch  '/roommate_profile'            => 'roommate_listings#update'
  delete '/roommate_profile'            => 'roommate_listings#delete'
  get    '/activate_roommate_profile'   => 'roommate_listings#activate',   as: 'activate_roommate_listing'
  get    '/deacticate_roommate_profile' => 'roommate_listings#deactivate', as: 'deactivate_roommate_listing'

  ##
  # Bookmark Management
  #

  post '/bookmark/:id'          => 'bookmarks#create',    as: 'create_bookmark'
  delete '/bookmark/:id'    => 'bookmarks#delete',    as: 'delete_bookmark'

  ##
  # Messaging
  # 
  post '/send_message' => 'messages#send_message', as: 'send_message'


  root 'info#home'


  ##
  # View Listings
  #
  get 'choose_school' => 'listings#choose_school', as: 'choose_school'
  get 'school_list'   => 'listings#school_list',   as: 'school_list'

  scope '/:school_code', constraints: SchoolConstraint do
    root to:                  'listings#view_school',            as: 'school_home'
    get  '/marketplace'     => 'listings#view_marketplace',       as: 'view_marketplace'
    get  '/marketplace/:id' => 'listings#view_item',              as: 'view_item'
    get  '/roommates'       => 'listings#view_roommate_listings', as: 'view_roommate_listings'
    get  '/roommates/:id'   => 'listings#view_roommate_listing',  as: 'view_roommate_listing'
    get  '/admin'           => 'school_admin#dashboard',          as: 'school_admin'
    get  '/admin/analytics' => 'school_admin#analytics',          as: 'school_admin_analytics'
    post '/admin/analytics' => 'school_admin#analytics'
    get  '/admin/monitor'   => 'school_admin#monitor',   as: 'school_admin_monitor'
    scope '/:property_type', constraints: PropertyTypeConstraint do
      root to:      'listings#view_properties', as: 'view_properties'
      get '/:id' => 'listings#view_property',   as: 'view_property'
    end
  end


end