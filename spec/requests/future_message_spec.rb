# spec/controllers/future_messages_controller_spec.rb
require 'rails_helper'

RSpec.describe FutureMessagesController, type: :controller do
  let(:valid_attributes) {
    { content: 'Hello Future!', published_at: Time.now + 1.day, user_id: user.id }
  }

  let(:invalid_attributes) {
    { content: '', published_at: nil }
  }

  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user  # Assuming Devise for user authentication; adjust as necessary
  end

  describe "GET #index" do
    it "returns a success response" do
      FutureMessage.create! valid_attributes
      get :index
      expect(response).to be_successful  # or use expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      future_message = FutureMessage.create! valid_attributes
      get :show, params: { id: future_message.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      future_message = FutureMessage.create! valid_attributes
      get :edit, params: { id: future_message.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new FutureMessage" do
        expect {
          post :create, params: { future_message: valid_attributes }
        }.to change(FutureMessage, :count).by(1)
      end

      it "redirects to the created future_message" do
        post :create, params: { future_message: valid_attributes }
        expect(response).to redirect_to(FutureMessage.last)
      end
    end

    context "with invalid parameters" do
      it "does not create a new FutureMessage" do
        expect {
          post :create, params: { future_message: invalid_attributes }
        }.not_to change(FutureMessage, :count)
      end

      it "returns a successful response (i.e., to display the 'new' template)" do
        post :create, params: { future_message: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { content: 'Updated Future Message', published_at: Time.now + 2.days }
      }

      it "updates the requested future_message" do
        future_message = FutureMessage.create! valid_attributes
        put :update, params: { id: future_message.id, future_message: new_attributes }
        future_message.reload
        expect(future_message.content).to eq('Updated Future Message')
      end

      it "redirects to the future_message" do
        future_message = FutureMessage.create! valid_attributes
        put :update, params: { id: future_message.id, future_message: new_attributes }
        expect(response).to redirect_to(future_message)
      end
    end

    context "with invalid parameters" do
      it "returns a successful response (i.e., to display the 'edit' template)" do
        future_message = FutureMessage.create! valid_attributes
        put :update, params: { id: future_message.id, future_message: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested future_message" do
      future_message = FutureMessage.create! valid_attributes
      expect {
        delete :destroy, params: { id: future_message.id }
      }.to change(FutureMessage, :count).by(-1)
    end

    it "redirects to the future_messages list" do
      future_message = FutureMessage.create! valid_attributes
      delete :destroy, params: { id: future_message.id }
      expect(response).to redirect_to(future_messages_url)
    end
  end
end
