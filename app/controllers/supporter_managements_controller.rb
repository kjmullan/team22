class SupporterManagementsController < ApplicationController
    before_action :authenticate_user!
  
    # index
    def index
        if current_user.supporter?
            @young_people = current_user.young_people
        else
            redirect_to root_path, alert: 'Access Denied'
        end
    end
  
    # view details
    def show
      @young_person = @supporter_management.young_person
    end
    
    # create
    def create
      @supporter_management = current_user.supporter_managements.build(supporter_management_params)
  
      if @supporter_management.save
        redirect_to @supporter_management, notice: 'Supporter management was successfully created.'
      else
        render :new
      end
    end
  
    # update
    def update
      if @supporter_management.update(supporter_management_params)
        redirect_to @supporter_management, notice: 'Supporter management was successfully updated.'
      else
        render :edit
      end
    end
  
    # delete
    def destroy
      @supporter_management.destroy
      redirect_to supporter_managements_url, notice: 'Supporter management was successfully destroyed.'
    end
  
    private
      # setting
      def set_supporter_management
        @supporter_management = current_user.supporter_managements.find(params[:id])
      end
  
      # param passing
      def supporter_management_params
        params.require(:supporter_management).permit(:young_person_id, :status)
      end
  end
  