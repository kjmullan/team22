# == Schema Information
#
# Table name: young_person_managements
#
#  id              :uuid             not null, primary key
#  active          :integer          default("active")
#  commit          :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  supporter_id    :uuid             not null
#  young_person_id :uuid             not null
#
# Indexes
#
#  index_yp_managements_on_id            (id)
#  index_yp_managements_on_supporter_id  (supporter_id)
#  index_yp_managements_on_yp_id         (young_person_id)
#
# Foreign Keys
#
#  fk_rails_...  (supporter_id => supporters.user_id)
#  fk_rails_...  (young_person_id => young_people.user_id)
#
class YoungPersonManagement < ApplicationRecord
  self.primary_keys = :id

  belongs_to :supporter, class_name: 'User'
  belongs_to :young_person, class_name: 'User'
  enum active: { active: 1, unactive: 0 }

end


