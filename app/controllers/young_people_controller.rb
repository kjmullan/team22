class YoungPeopleController < ApplicationController
    before_action :authenticate_user!
    before_action :set_young_person, only: [:show, :destroy]
  
    def destroy
        @young_person = YoungPerson.find(params[:id])  # This ensures you are finding by young_person's ID
        if @young_person.update(passed_away: true)
          redirect_to young_people_url, notice: 'Successfully updated the status.'
        else
          redirect_to young_people_url, alert: 'Failed to update the status.'
        end
    end
  
    private
    def set_young_person
      @young_person = YoungPerson.find_by(user_id: params[:user_id])
      redirect_to root_path, alert: 'Invalid user.' unless @young_person && current_user.can_manage?(@young_person)
    end
  end
  