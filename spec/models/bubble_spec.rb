# == Schema Information
#
# Table name: bubbles
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  holder_id  :bigint           not null
#
# Indexes
#
#  index_bubbles_on_holder_id  (holder_id)
#
require 'rails_helper'

RSpec.describe Bubble, type: :model do
  let(:user) { FactoryBot.create(:user, :young_person) }
  let(:young_person_1) { FactoryBot.create(:young_person, user: user) }
  let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
  let!(:user_2) { FactoryBot.create(:user, :loved_one) }
  let!(:member) { FactoryBot.create(:bubble_member, user: user_2) }

  describe "#holder" do
    it "links to a young person object" do
      expect(bubble.holder).to eq young_person_1
    end
  end

  describe "#members" do
    before do
      bubble.members << member
    end
    it "links to a bubble member object" do
      expect(bubble.members).to include member
    end
  end

  describe "#name" do
    it "links to a bubble member object" do
      expect(bubble.name).to eq "friends"
    end
  end
end
