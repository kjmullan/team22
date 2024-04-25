# == Schema Information
#
# Table name: future_messages
#
#  id           :uuid             not null, primary key
#  content      :text
#  publishable  :boolean          default(FALSE)
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_future_messages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => young_people.user_id)
#
class FutureMessage < ApplicationRecord
  belongs_to :young_person, foreign_key: 'user_id', primary_key: 'user_id'
  
  has_many :future_messages_bubbles
  has_many :bubbles, through: :future_messages_bubbles
  has_many :future_message_alerts, dependent: :destroy
  validates :content, presence: true
  validates :published_at, presence: true

  def has_active_alert?
    future_message_alerts.where(active: true).exists?
  end
end
