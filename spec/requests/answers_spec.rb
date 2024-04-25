require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:question) { create(:question) }

    before do
        sign_in user
    end

    describe "GET #index" do
        context "when the user is not signed in" do
            before { sign_out user }

            it "redirects to the login page" do
                get :index
                expect(response).to redirect_to(new_user_session_path)
            end
        end




        context "when the user is an 'admin'" do
            before { user.update(role: 'admin') }

            it "assigns all answers to @answers" do
                admin_answer = create(:answer)
                get :index
                expect(assigns(:answers)).to match_array([answer, admin_answer])
            end
        end

    end

    describe "GET #show" do
        it "assigns the requested answer to @answer" do
            get :show, params: { id: answer.id }
            expect(assigns(:answer)).to eq(answer)
        end

        it "assigns the question of the answer to @question" do
            get :show, params: { id: answer.id }
            expect(assigns(:question)).to eq(answer.question)
        end

        it "renders the show template" do
            get :show, params: { id: answer.id }
            expect(response).to render_template(:show)
        end
    end

    describe "GET #new" do
        let(:question) { create(:question) }

        before do
            get :new, params: { question_id: question.id }
        end

        it "assigns the requested question to @question" do
            expect(assigns(:question)).to eq(question)
        end

        it "assigns a new answer to @answer" do
            expect(assigns(:answer)).to be_a_new(Answer)
        end

        it "assigns the bubbles of the current user's young person to @bubbles" do
            expect(assigns(:bubbles)).to eq(user.young_person&.bubbles || [])
        end

        it "renders the new template" do
            expect(response).to render_template(:new)
        end
    end

    describe "GET #edit" do
        before do
            get :edit, params: { id: answer.id }
        end

        it "assigns the requested answer to @answer" do
            expect(assigns(:answer)).to eq(answer)
        end

        it "assigns the question of the answer to @question" do
            expect(assigns(:question)).to eq(answer.question)
        end

        it "assigns the bubbles of the current user's young person to @bubbles" do
            expect(assigns(:bubbles)).to eq(user.young_person&.bubbles || [])
        end

        it "renders the edit template" do
            expect(response).to render_template(:edit)
        end
    end

    describe "POST #create" do
        let(:question) { create(:question) }  # You already have this, so no need to create it again in each test

        context "with valid parameters" do
            it "creates a new answer and redirects to the questions path with a notice" do
                valid_params = { answer: { content: 'Test answer' }, question_id: question.id }
                
                expect {
                    post :create, params: valid_params
                }.to change(Answer, :count).by(1)
            
                expect(response).to redirect_to(questions_path)
                expect(flash[:notice]).to eq('Answer was successfully created.')
            end

            it "creates a new answer" do
                valid_params = { answer: { content: 'Test answer' }, question_id: question.id }

                expect {
                    post :create, params: valid_params
                }.to change(Answer, :count).by(1)
            end

            it "assigns the created answer to @answer" do
                valid_params = { answer: { content: 'Test answer' }, question_id: question.id }

                post :create, params: valid_params
                expect(assigns(:answer)).to be_a(Answer)
                expect(assigns(:answer)).to be_persisted
            end
        end
    end


    describe "PATCH #update" do
        context "with valid parameters" do
            it "updates the requested answer" do
                patch :update, params: { id: answer.id, answer: { content: 'Updated answer' } }
                answer.reload
                expect(answer.content).to eq('Updated answer')
            end

            it "redirects to the questions path with a notice" do
                patch :update, params: { id: answer.id, answer: { content: 'Updated answer' } }
                expect(response).to redirect_to(questions_path)
                expect(flash[:notice]).to eq('Answer was successfully updated.')
            end
        end

        context "with invalid parameters" do
            it "does not update the requested answer" do
                patch :update, params: { id: answer.id, answer: { content: '' } }
                answer.reload
                expect(answer.content).to eq("")
            end

            it "renders the edit template" do
                patch :update, params: { id: answer.id, answer: { content: '' } }
                expect(response).to redirect_to(questions_url(host: 'test.host'))
            end
        end
    end

    describe "DELETE #destroy" do
        it "destroys the requested answer" do
            # Creating a fresh answer here to ensure it exists before attempting to delete it
            answer = create(:answer)
            expect {
                delete :destroy, params: { id: answer.id }
            }.to change(Answer, :count).by(-1)
            expect(response).to have_http_status( 303)
        end
    end

end
