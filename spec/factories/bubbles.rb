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
FactoryBot.define do
  factory :bubble do
    name { "bubble" }
    association :holder, factory: :young_person
  end
  factory :family_bubble, class: "Bubble" do
    name { "family" }
    association :holder, factory: :young_person
  end

  factory :friends_bubble, class: "Bubble" do
    name { "friends" }
    association :holder, factory: :young_person
  end
end
