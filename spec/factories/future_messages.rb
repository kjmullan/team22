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
FactoryBot.define do
  factory :future_message do
    id { "" }
    content { "MyText" }
    published_at { "2024-03-13 20:28:52" }
    user { nil }
  end
end
