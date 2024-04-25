require 'rails_helper'

describe 'bubbles' do
    let!(:user) { FactoryBot.create(:user, :young_person) }
    let!(:young_person_1) { FactoryBot.create(:young_person, user: user) }
    let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}
    let!(:member) { FactoryBot.create(:bubble_invite, young_person: young_person_1) }
    before do
        bubble.members << member
    end

    describe 'GET /api/v1/members' do
        before do
            login_as user
            get '/api/v1/members'
        end
        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'list of all members' do
            expect(response.body).to include(member.id.to_s)
        end
    end

    describe 'GET /api/v1/members/:id' do
        before do
            login_as user
            get "/api/v1/members/#{member.id}"
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'shows a member\'s details' do
            expect(response.body).to include("\"id\":#{member.id}")
        end
    end

    describe 'POST /api/v1/members' do
        let!(:name) { "Everton" }
        let!(:email) { "Genius@gmail.com" }

        before do
            login_as user
            post '/api/v1/members', :params => { member: {name: name, email: email} }
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :created
        end

        it 'creates a new member' do
            expect(response.body).to include(name)
        end
    end

    describe 'DELETE /api/v1/members/:id' do

        before do
            login_as user
            delete "/api/v1/members/#{member.id}"
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'removes the member' do
            expect(response.body).to include('"status":"deleted"')
        end
    end

    describe 'PUT /api/v1/members/:id' do
        let!(:new_name) { "elizabeth" }
        let!(:new_email) { "much_loved@gmail.com"}

        before do
            login_as user
            put "/api/v1/members/#{member.id}", :params => { :member => { name: new_name, email: new_email}}
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'removes the bubble' do
            expect(response.body).to include("\"name\":\"#{new_name}\"")
        end
    end
end
