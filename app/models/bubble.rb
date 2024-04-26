# == Schema Information
#
# Table name: bubbles
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  holder_id  :bigint           not null
#
# Indexes
#
#  index_bubbles_on_holder_id  (holder_id)
#
class Bubble < ApplicationRecord
    belongs_to :holder, class_name: "YoungPerson"
    # optional change
    # has_many :members, through: :bubble_invite, optional: true
    has_many :bubble_invites
    has_many :members, through: :bubble_invites, source: :user
    has_and_belongs_to_many :members, class_name: "BubbleInvite",
    association_foreign_key: "member_id", join_table: "bubble_members_bubbles"
    has_many :answers_bubbles, dependent: :destroy
    has_many :answers, through: :answers_bubbles
end

