# == Schema Information
#
# Table name: ques_categories
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class QuesCategory < ApplicationRecord
    has_many :questions, dependent: :destroy
    validates :active, presence: { message: "Please specify if the category is active" }
    validates :name, presence: { message: "Name cannot be blank" }
end
