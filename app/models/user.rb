# include ActiveModel::Model

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  belongs_to :account
  
  validate  :user_role_is_valid, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate  :code_is_legitimate, on: :create, if: "self.role == 'student'"
  validate  :email_domain_is_edu, on: :create, if: "self.role == 'student'"
  validates :telephone, presence: true, on: :create, if: "self.role == 'landlord'"
  validate  :telephone_is_valid, on: :create, if: "self.role == 'landlord'"
  before_create :set_defaults

  attr_accessor :code, :role, :company_name, :telephone

  def user_role_is_valid
    errors[:base] << "The role you assigned for yourself is invalid." unless ['landlord','student'].include? self.role
  end

  def code_is_legitimate
    errors[:base] << "You didn't choose a school." unless self.code.present? && School.where(code:self.code, active: true).present?
  end

  def email_domain_is_edu
    errors[:base] << "You must register with a .edu email address." unless self.email.present? && self.email.end_with?(".edu")
  end

  def telephone_is_valid
    errors[:base] << "You must use a valid telephone number" unless self.telephone.is_telephone?
  end

  def set_defaults
    self.notify_listings = true
    self.notify_newsletter = true
    self.notify_major_announcements = true
    self.active = true
    self.company_name = "#{self.first_name} #{self.last_name}" if self.role == 'landlord' && self.company_name.empty?
    self.account_id = Account.create(name: self.company_name, role: self.role, code: self.code, email: self.email, telephone: self.telephone).id
  end

  def school
    self.account.school
  end

  def deactivate
    self.update(active: false, unconfirmed_email: self.email, deactivated_at: DateTime.now)
  end

  def reactivate
    self.update(active: true)
    self.account.update(active: true)
  end

  def active_for_authentication?
    super && self.active?
  end

  def confirm!
    super
    self.reactivate
  end

  

end