# == Schema Information
#
# Table name: emotional_support_requests
#
#  id         :uuid             not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_emotional_support_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# require 'rails_helper'

# RSpec.describe EmotionalSupportRequest, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
