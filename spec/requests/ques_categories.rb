# spec/controllers/ques_categories_controller_spec.rb
require 'rails_helper'

RSpec.describe QuesCategoriesController, type: :controller do
  let(:valid_attributes) {
    { name: "My bucket list", active: 'true' }
  }

  let(:invalid_attributes) {
    { name: "", active: nil }
  }

  before do
    user = create(:user)
    sign_in user
  end

  describe "GET #index" do
    it "renders a successful response" do
      QuesCategory.create! valid_attributes
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "renders a successful response" do
      ques_category = QuesCategory.create! valid_attributes
      get :show, params: { id: ques_category.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "renders a successful response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "render a successful response" do
      ques_category = QuesCategory.create! valid_attributes
      get :edit, params: { id: ques_category.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new QuesCategory" do
        expect {
          post :create, params: { ques_category: valid_attributes }
        }.to change(QuesCategory, :count).by(1)
      end

      it "redirects to the created ques_category" do
        post :create, params: { ques_category: valid_attributes }
        expect(response).to redirect_to(ques_categories_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new QuesCategory and re-renders the 'new' template " do
        post :create, params: { ques_category: invalid_attributes }
      expect(QuesCategory.count).to eq(0)
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders a successful response (i.e., to display the 'new' template)" do
        post :create, params: { ques_category: invalid_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:ques_category).errors).not_to be_empty
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:existing_category) {create(:ques_category)}
      let(:new_attributes) {
        { name: "Final wish", active: true }
      }

      it "updates the requested ques_category" do
        ques_category = QuesCategory.create! valid_attributes
        patch :update, params: { id: ques_category.id, ques_category: new_attributes }
        ques_category.reload
        expect(ques_category.name).to eq("Final wish")
        expect(ques_category.active).to be true
      end

      it "redirects to the ques_category" do
        ques_category = QuesCategory.create! valid_attributes
        patch :update, params: { id: ques_category.id, ques_category: new_attributes }
        ques_category.reload
        expect(response).to redirect_to(ques_categories_path)
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e., to display the 'edit' template)" do
        ques_category = QuesCategory.create! valid_attributes
        patch :edit, params: { id: ques_category.id, ques_category: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested ques_category" do
      ques_category = QuesCategory.create! valid_attributes
      expect {
        delete :destroy, params: { id: ques_category.id }
      }.to change(QuesCategory, :count).by(-1)
    end

    it "redirects to the ques_categories list" do
      ques_category = QuesCategory.create! valid_attributes
      delete :destroy, params: { id: ques_category.id }
      expect(response).to redirect_to(ques_categories_url(host: 'test.host'))
    end
  end
end
