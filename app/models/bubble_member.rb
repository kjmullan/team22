# == Schema Information
#
# Table name: bubble_members
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_bubble_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class BubbleMember < ApplicationRecord
  belongs_to :user

  # needds to be changed.
  has_many :invites, class_name: :BubbleInvite
  has_and_belongs_to_many :bubbles, foreign_key: "member_id",
  join_table: "bubble_members_bubbles"
end
