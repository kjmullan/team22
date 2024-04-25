# == Schema Information
#
# Table name: answer_alerts
#
#  id         :uuid             not null, primary key
#  active     :boolean          default(TRUE)
#  commit     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  answer_id  :uuid             not null
#
# Indexes
#
#  index_answer_alerts_on_answer_id  (answer_id)
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id) ON DELETE => cascade
#
class AnswerAlert < ApplicationRecord
  belongs_to :answer
  validates :commit, presence: true
  validates :answer_id, presence: true
end

  
