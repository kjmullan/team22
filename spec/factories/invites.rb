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
FactoryBot.define do
  factory :invite do
    code { "MyString" }
    email { "MyString" }
    used { false }
  end
end
