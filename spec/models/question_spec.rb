# == Schema Information
#
# Table name: questions
#
#  id               :uuid             not null, primary key
#  active           :boolean          default(TRUE)
#  change           :boolean          default(FALSE)
#  content          :text
#  sensitivity      :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ques_category_id :bigint
#
# Foreign Keys
#
#  fk_rails_...  (ques_category_id => ques_categories.id)
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  require 'rails_helper'

  describe 'associations' do
    it { is_expected.to belong_to(:ques_category).optional }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:change_requests).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:ques_category_id) }
  end

  context 'with valid attributes' do
    it 'is valid' do
      question = build(:question)
      expect(question).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is not valid without content' do
      question = build(:question, content: nil)
      expect(question).not_to be_valid
    end

    it 'is not valid without a ques_category_id' do
      question = build(:question, ques_category_id: nil)
      expect(question).not_to be_valid
    end
  end

  describe '#log_before_destroy' do
    it 'logs information before destruction' do
      question = create(:question)
      allow(Rails.logger).to receive(:debug)  # Allow all debug messages

      expect(Rails.logger).to receive(:debug).with("Before destroy callback for Question with id: #{question.id}")
      question.run_callbacks(:destroy)
    end
  end

end
