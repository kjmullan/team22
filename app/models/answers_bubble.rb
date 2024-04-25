# == Schema Information
#
# Table name: answers_bubbles
#
#  answer_id :uuid             not null
#  bubble_id :uuid             not null
#
# Indexes
#
#  index_answers_bubbles_on_answer_id_and_bubble_id  (answer_id,bubble_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (answer_id => answers.id)
#  fk_rails_...  (bubble_id => bubbles.id)
#
class AnswersBubble < ApplicationRecord
    belongs_to :answer
    belongs_to :bubble
  end