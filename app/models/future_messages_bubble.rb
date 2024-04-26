# == Schema Information
#
# Table name: future_messages_bubbles
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bubble_id         :uuid             not null
#  future_message_id :uuid             not null
#
# Indexes
#
#  index_fmsg_bubbles_on_fmsg_id_and_bubble_id         (future_message_id,bubble_id) UNIQUE
#  index_future_messages_bubbles_on_bubble_id          (bubble_id)
#  index_future_messages_bubbles_on_future_message_id  (future_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (bubble_id => bubbles.id)
#  fk_rails_...  (future_message_id => future_messages.id)
#
class FutureMessagesBubble < ApplicationRecord
    belongs_to :future_message, class_name: 'FutureMessage', foreign_key: 'future_message_id'
    belongs_to :bubble, class_name: 'Bubble', foreign_key: 'bubble_id'
  end
  
