# spec/controllers/young_person_managements_controller_spec.rb
describe YoungPersonManagementsController, type: :controller do
    describe 'DELETE #destroy' do
      let(:young_person) { create(:user, role: :young_person) }
  
      before { sign_in user }
  
      context 'when user is authorized' do
        let(:user) { create(:user, :supporter) }
  
        it 'sets passed_away to true' do
          delete :destroy, params: { id: young_person.id }
          young_person.reload
          expect(young_person.passed_away).to be true
        end
      end
  
      context 'when user is unauthorized' do
        let(:user) { create(:user, :young_person) }
  
        it 'does not allow the action' do
          delete :destroy, params: { id: young_person.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
  