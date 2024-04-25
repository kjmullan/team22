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
class Question < ApplicationRecord
  has_many :answers
  has_many :change_requests, dependent: :destroy
  belongs_to :ques_category, optional: true
  validates :content, presence: true
  validates :ques_category_id, presence: true
  validates :sensitivity, inclusion: { in: [true, false] }
  private

  def log_before_destroy
    Rails.logger.debug("Before destroy callback for Question with id: #{id}")
  end

end
