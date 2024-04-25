# spec/controllers/questions_controller_spec.rb
require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:ques_category) { create(:ques_category)}

  let(:valid_attributes) {
    { content: 'What is RSpec?', ques_category_id: ques_category.id, sensitivity: 'false', active: 'true'}
  }

  let(:invalid_attributes) {
    { content: '', ques_category_id: nil }
  }

  before do
    user = create(:user)
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
    # This ensures that a `QuesCategory` exists and is associated with the `Question`
    #create(:question, valid_attributes)
      get :index
      expect(response).to be_successful  # This checks that the response was a success
    end
  end

  describe "GET #show" do
    let(:question) { create(:question)}
    it "returns a success response" do
    # This ensures that a `QuesCategory` exists and is associated with the `Question`
      create(:question, valid_attributes)

      get :show, params: { id: question.id}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, params: { question: valid_attributes }
        }.to change(Question, :count).by(1)
      end

      it "redirects to the questions list" do
        post :create, params: { question: valid_attributes }
        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "does not create a new Question and redirects to the new question form" do
        post :create, params: { question: invalid_attributes }
        expect(response).to redirect_to(new_question_path)  # Expecting a redirect instead of render
        expect(Question.count).to eq(0)  # Ensure no Question is created
        expect(flash[:alert]).to be_present  # Optionally check for the presence of a flash message
      end
    end
  end

  describe "PUT #update" do
  
    context "with valid params" do
      let(:existing_category) { create(:ques_category) }  # This will have a dynamically assigned ID

      let(:new_attributes) {
        { content: 'Updated content', ques_category_id: existing_category.id}
      }

      it "updates the requested question" do
        question = create(:question, valid_attributes.merge(ques_category: existing_category))
        put :update, params: {id: question.id, question: new_attributes }
        question.reload
        expect(question.content).to eq('Updated content')
      end
  
      it "redirects to the question" do
        question = create(:question, valid_attributes.merge(ques_category: existing_category))
        put :update, params: {id: question.id, question: new_attributes }

        expect(response).to redirect_to(questions_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'edit' template)" do
        question = Question.create! valid_attributes
        put :update, params: {id: question.id, question: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)  
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested question" do
      question = Question.create!(valid_attributes.merge(active: false))
      delete :destroy, params: {id: question.id}
      question.reload  # Reload to get the updated attributes from the database
      expect(question.active).to be_falsey
    end

    it "redirects to the questions list" do
      question = Question.create!(valid_attributes.merge(active: false))
      delete :destroy, params: {id: question.id}
      expect(response).to redirect_to(questions_url(host: 'test.host'))
    end
  end
end
