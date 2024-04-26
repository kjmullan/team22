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
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:answer_alerts) }
    it { is_expected.to have_many_attached(:media) }
    it { is_expected.to have_and_belong_to_many(:bubbles) }
  end


  describe '#has_active_alert?' do
    let(:answer) { create(:answer) }
    
    context 'when there are active alerts' do
      before { create(:answer_alert, answer: answer, active: true) }

      it 'returns true' do
        expect(answer.has_active_alert?).to be true
      end
    end

    context 'when there are no active alerts' do
      it 'returns false' do
        expect(answer.has_active_alert?).to be false
      end
    end
  end
end
