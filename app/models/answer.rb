# == Schema Information
#
# Table name: answers
#
#  id          :uuid             not null, primary key
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#  user_id     :uuid
#
# Indexes
#
#  index_answers_on_question_id              (question_id)
#  index_answers_on_question_id_and_user_id  (question_id,user_id) UNIQUE
#  index_answers_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (user_id => young_people.user_id)
#
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :young_person, foreign_key: 'user_id', primary_key: 'user_id'
  has_many_attached :media
  has_many :answers_bubbles
  has_many :bubbles, through: :answers_bubbles
  has_many :answer_alerts, dependent: :destroy
  validates :user_id, uniqueness: { scope: :question_id }

  def has_active_alert?
    answer_alerts.where(active: true).exists?
  end

end
