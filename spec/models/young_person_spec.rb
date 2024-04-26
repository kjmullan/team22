# == Schema Information
#
# Table name: young_people
#
#  id          :bigint           not null, primary key
#  passed_away :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_young_people_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe YoungPerson, type: :model do
  let(:user) { FactoryBot.create(:user, :young_person) }
  let(:young_person_1) { FactoryBot.create(:young_person, user: user) }
  let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
  let!(:user_2) { FactoryBot.create(:user, :loved_one) }
  let!(:bubble_member_1) { FactoryBot.create(:bubble_member, user: user_2) }

  describe "#holder" do
    it "links to a young person object" do
      expect(young_person_1.user).to eq user
    end
  end

  describe "#members" do
    it "links to a bubble member object" do
      expect(young_person_1.bubbles).to include bubble
    end
  end

  describe "#user_id" do
    it "provides user_id" do
      expect(young_person_1.user_id).to eq user.id
    end
  end
end
