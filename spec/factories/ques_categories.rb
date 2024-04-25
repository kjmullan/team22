# == Schema Information
#
# Table name: ques_categories
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :ques_category do
    name { "My bucket list" } 
    active { true }
  end
end
