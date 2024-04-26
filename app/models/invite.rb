# == Schema Information
#
# Table name: invites
#
#  id              :bigint           not null, primary key
#  code            :string
#  email           :string
#  expiration_date :datetime
#  message         :text
#  role            :string
#  token           :string
#  used            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :uuid
#
class Invite < ApplicationRecord
  belongs_to :user
  before_create :set_expiration_date
  validates :role, inclusion: { in: ['admin', 'supporter', 'young_person', 'loved_one'] }, allow_blank: true
  validates :message, length: { maximum: 500 }, allow_blank: true
  validates :token, uniqueness: true, presence: true

  before_validation :generate_token, on: :create
  
  private

  def generate_token
    self.token ||= SecureRandom.hex(10)  # Generate a token if one isn't already set
  end

  def set_expiration_date
    self.expiration_date ||= 5.days.from_now
  end
end
