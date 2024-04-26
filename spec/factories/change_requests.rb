# == Schema Information
#
# Table name: change_request
#
#  id          :uuid             not null, primary key
#  content     :text
#  status      :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#
# Indexes
#
#  index_change_request_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
FactoryBot.define do
  factory :change_request do
    content { "Please change the sensitivity." }
    association :question
  end
end
