# == Schema Information
#
# Table name: supporters
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_supporters_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Supporter < ApplicationRecord
  belongs_to :user
  has_many :invites, class_name: "BubbleInvite"
end
