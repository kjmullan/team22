# == Schema Information
#
# Table name: users
#
#  id                       :uuid             not null, primary key
#  bypass_invite_validation :boolean
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  email                    :string
#  encrypted_password       :string           default(""), not null
#  invite_code              :string
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  name                     :string
#  password                 :string
#  pronouns                 :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  role                     :integer
#  sign_in_count            :integer          default(0), not null
#  status                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_id                    (id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  # Constants and Enums
  self.primary_key = 'id'
  enum role: { young_person: 0, loved_one: 1, supporter: 2, admin: 3 }

  # Validations
  before_save :downcase_email
  validates :password, presence: true, if: :password_required?
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :invite_code, presence: true, unless: :bypass_invite_validation, on: :create
  validate :valid_invite_code, unless: :bypass_invite_validation, on: :create

  # Associations
  has_one :young_person
  has_one :bubble_member
  has_many :supporter_managements, foreign_key: "supporter_id", class_name: "YoungPersonManagement"
  has_many :young_people, through: :supporter_managements, source: :young_person
  has_many :young_person_managements, foreign_key: "young_person_id", class_name: "YoungPersonManagement"
  has_many :supporters, through: :young_person_managements, source: :supporter
  has_many :answers
  has_many :emotional_supports
  has_many :invites  # Assuming you have this association for managing related invites

  # Methods
  def downcase_email
    self.email = email.downcase
  end

  def password_required?
    password.present? || password_confirmation.present? || encrypted_password.blank?
  end

  def generate_invite_token
    SecureRandom.hex(10)  # Generates a random token for the invite
  end

  private

  def valid_invite_code
    return if bypass_invite_validation
  
    invite = Invite.find_by(token: invite_code)
    if invite.nil? || invite.expiration_date < Time.current || invite.used
      errors.add(:invite_code, 'is invalid, expired, or has already been used')
    end
  end
end


