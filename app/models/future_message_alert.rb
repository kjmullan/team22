# == Schema Information
#
# Table name: future_message_alerts
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  commit            :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_future_message_alerts_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (future_message_id => future_messages.id)
#
class FutureMessageAlert < ApplicationRecord
    belongs_to :future_message
    validates :commit, presence: true
    validates :future_message_id, presence: true
end
