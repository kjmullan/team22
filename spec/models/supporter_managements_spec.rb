require 'rails_helper'

RSpec.describe SupporterManagement, type: :model do
    describe 'validations' do
        it 'is valid with valid attributes' do
            supporter_management = build(:supporter_management)
            expect(supporter_management).to be_valid
        end

        it 'is not valid without a young person id' do
            supporter_management = build(:supporter_management, young_person_id: nil)
            expect(supporter_management).not_to be_valid
        end
    end

    describe 'associations' do
        it { should belong_to(:user) }
        it { should belong_to(:young_person) }
    end
end
