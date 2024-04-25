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
class ChangeRequest < ApplicationRecord
    self.table_name = "change_request"
    validates :content, presence: { message: "Content cannot be blank"}
    belongs_to :question
end
