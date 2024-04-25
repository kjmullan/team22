require 'rails_helper'

RSpec.describe AnswerAlertsController, type: :controller do
  let(:user) { create(:user) }
  let(:young_person) { create(:user, :young_person) }
  let(:answer) { create(:answer, user: young_person) }
  let(:answer_alert) { create(:answer_alert, answer: answer) }

  before do
    sign_in user
    get :index 
  end

  describe "GET #index" do
    before do
      allow(user).to receive(:young_people).and_return([young_person])
      get :index
    end


    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new AnswerAlert to @answer_alert" do
      get :new
      expect(assigns(:answer_alert)).to be_a_new(AnswerAlert)
    end
  end

    describe "POST #create" do
    context "with valid parameters" do
        let(:valid_attributes) { attributes_for(:answer_alert, answer_id: answer.id).except(:active) }

        it "creates a new AnswerAlert" do
        expect {
            post :create, params: { answer_alert: valid_attributes }
        }.to change(AnswerAlert, :count).by(1)
        end

        it "redirects to the AnswerAlert show page" do
        post :create, params: { answer_alert: valid_attributes }
        expect(response).to redirect_to(AnswerAlert.last)
        end
    end

    context "with invalid parameters" do
        let(:invalid_attributes) { attributes_for(:answer_alert, answer_id: nil).except(:active) }

        it "does not create a new AnswerAlert" do
        expect {
            post :create, params: { answer_alert: invalid_attributes }
        }.not_to change(AnswerAlert, :count)
        end

        it "re-renders the 'new' template" do
        post :create, params: { answer_alert: invalid_attributes }
        expect(response).to render_template("new")
        end
    end
    end



  describe "GET #show" do
    it "assigns the requested AnswerAlert to @answer_alert" do
      get :show, params: { id: answer_alert.id }
      expect(assigns(:answer_alert)).to eq(answer_alert)
    end
  end

  describe "GET #edit" do
    it "assigns the requested AnswerAlert to @answer_alert" do
      get :edit, params: { id: answer_alert.id }
      expect(assigns(:answer_alert)).to eq(answer_alert)
    end
  end

  describe "POST #update" do
    context "with valid parameters" do
      it "updates the requested AnswerAlert" do
        put :update, params: { id: answer_alert.id, answer_alert: { commit: "Updated commit" } }
        answer_alert.reload
        expect(answer_alert.commit).to eq("Updated commit")
      end

      it "redirects to the AnswerAlert" do
        put :update, params: { id: answer_alert.id, answer_alert: { commit: "Updated commit" } }
        expect(response).to redirect_to(answer_alert)
      end
    end

    context "with invalid parameters" do
      it "does not update the AnswerAlert" do
        put :update, params: { id: answer_alert.id, answer_alert: { commit: nil } }
        previous_commit = answer_alert.commit
        answer_alert.reload
        expect(answer_alert.commit).to eq(previous_commit)
      end

      it "re-renders the 'edit' template" do
        put :update, params: { id: answer_alert.id, answer_alert: { commit: nil } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "sets the AnswerAlert to inactive" do
      delete :destroy, params: { id: answer_alert.id }
      answer_alert.reload
      expect(answer_alert.active).to be false
    end

    it "redirects to the AnswerAlerts list" do
      delete :destroy, params: { id: answer_alert.id }
      expect(response).to redirect_to(answer_alerts_url(host: 'test.host'))
    end
  end
end
