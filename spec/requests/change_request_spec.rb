# spec/controllers/change_requests_controller_spec.rb
# spec/controllers/change_requests_controller_spec.rb
require 'rails_helper'

RSpec.describe ChangeRequestsController, type: :controller do
  let(:question) { FactoryBot.create(:question) }
  let(:user) { FactoryBot.create(:user) }  # Assuming a User factory exists

  let(:valid_attributes) {
    { content: 'Need to update this question.', status: 'pending', question_id: question.id }
  }
  let(:invalid_attributes) {
    { content: '', status: '', question_id: nil }
  }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "renders a successful response" do
      ChangeRequest.create! valid_attributes
      get :index
      expect(response).to be_successful 
    end
  end

  describe "GET #show" do
    it "renders a successful response" do
      change_request = ChangeRequest.create! valid_attributes
      get :show, params: { id: change_request.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "renders a successful response" do
      get :new, params: { question_id: question.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new ChangeRequest and redirects to the question list" do
        expect {
          post :create, params: { question_id: question.id, change_request: valid_attributes }
        }.to change(ChangeRequest, :count).by(1)
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new ChangeRequest and re-renders the 'new' template" do
        expect {
          post :create, params: { question_id: question.id, change_request: invalid_attributes }
        }.not_to change(ChangeRequest, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested change_request and redirects to the list" do
      change_request = ChangeRequest.create! valid_attributes
      expect {
        delete :destroy, params: { question_id: question.id, id: change_request.id }
      }.to change(ChangeRequest, :count).by(-1)
      expect(response).to redirect_to(change_requests_path)
    end
  end
end

