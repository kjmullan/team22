require 'rails_helper'

RSpec.describe 'Bubble Management', type: :request do
    let(:user) { FactoryBot.create(:user, :young_person) }
    let(:young_person_1) { FactoryBot.create(:young_person, user: user) }
    let!(:bubble) { FactoryBot.create(:friends_bubble, holder: young_person_1)}

    describe 'GET /api/v1/bubbles' do
        before do
            login_as user
            get '/api/v1/bubbles'
        end
        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'Have a bubble named friends' do
            expect(response.body).to include(bubble.name)
        end
    end

    describe 'GET /api/v1/bubbles/:id' do
        before do
            login_as user
            get "/api/v1/bubbles/#{bubble.id}"
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'shows a bubble with no members' do
            expect(response.body).to include('"members":[]')
        end
    end

    describe 'POST /api/v1/bubbles' do
        let(:name) { "close_friends" }

        before do
            login_as user
            post '/api/v1/bubbles', :params => { :bubble => {
                name: name,
                holder_id: young_person_1.id }}
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :created
        end

        it 'created a new bubble' do
            expect(response.body).to include(name)
        end
    end

    describe 'DELETE /api/v1/bubbles/:id' do

        before do
            login_as user
            delete "/api/v1/bubbles/#{bubble.id}"
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :accepted
        end

        it 'removes the bubble' do
            expect(response.body).to include('"status":"deleted"')
        end
    end

    describe 'PUT /api/v1/bubbles/:id' do
        let(:new_name) { "found_family" }

        before do
            login_as user
            put "/api/v1/bubbles/#{bubble.id}", :params => { :bubble => { name: new_name }}
        end

        it 'responds with ok status' do
            expect(response).to have_http_status :ok
        end

        it 'removes the bubble' do
            expect(response.body).to include("\"name\":\"#{new_name}\"")
        end
    end
end
