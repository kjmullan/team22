require 'rails_helper'

context 'assigning members' do
    let!(:user) { FactoryBot.create(:user, :young_person) }
    let!(:young_person_1) { FactoryBot.create(:young_person, user: user) }
    let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
    # let!(:user_2) { FactoryBot.create(:user, :loved_one) }
    let!(:bubble_member_1) { FactoryBot.create(:bubble_invite, young_person: young_person_1) }

    describe 'POST /api/v1/bubbles/:id/assign' do
        before do
            login_as user
            post "/api/v1/bubbles/#{bubble.id}/assign", :params => { :member => { id: bubble_member_1.id }}
        end

        it 'responds with accepted status' do
            expect(response).to have_http_status :accepted
        end

        it 'adds the member' do
            expect(response.body).to include("\"name\":\"#{bubble_member_1.name}\"")
        end
    end

    describe 'POST /api/v1/bubbles/:id/unassign' do
        before do
            bubble.members << bubble_member_1
            login_as user
            post "/api/v1/bubbles/#{bubble.id}/unassign", :params => { :member => { id: bubble_member_1.id }}
        end

        it 'responds with accepted status' do
            expect(response).to have_http_status :accepted
        end

        it 'removes the member' do
            expect(response.body).to include('"members":[]')
        end
    end
end