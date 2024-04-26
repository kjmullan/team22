# == Schema Information
#
# Table name: invites
#
#  id              :bigint           not null, primary key
#  code            :string
#  email           :string
#  expiration_date :datetime
#  message         :text
#  role            :string
#  token           :string
#  used            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :uuid
#
require 'rails_helper'

RSpec.describe Invite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
