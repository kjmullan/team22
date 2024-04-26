# == Schema Information
#
# Table name: young_people
#
#  id          :bigint           not null, primary key
#  passed_away :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_young_people_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class YoungPerson < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id', primary_key: 'id'
  has_many :bubbles, foreign_key: "holder"
  has_many :invites, class_name: "BubbleInvite"
  has_many :bubble_members, through: :bubbles, source: :members
  has_many :emotional_supports, foreign_key: :user_id, primary_key: :user_id
  has_many :answers, through: :user
  has_many :future_messages, foreign_key: 'user_id', primary_key: 'user_id'
end

