class YoungPersonManagementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_young_person, only: [:show, :destroy]

  def index
    if current_user.role == 'supporter'
      young_people_ids = YoungPersonManagement.where(supporter_id: current_user.id).pluck(:young_person_id)
      @young_people = YoungPerson.where(user_id: young_people_ids)
    else
      redirect_to root_path, alert: 'Access Denied'
    end
  end 

  def show
    @user = User.find(params[:id])
    if @user.role == 'young_person'
      @young_person = @user.young_person
      @answers = @young_person.answers.includes(:question)
    else
      redirect_to root_path, alert: 'This user does not have answers or is not accessible.'
    end
  end


  def new
    @supporters = Supporter.where(active: true)
  
    if params[:user_id]
      @young_person = YoungPerson.find_by(user_id: params[:user_id])
      if @young_person.nil?
        flash[:alert] = "No young person found with the given user ID."
        @young_person_management = YoungPersonManagement.new
        render :new
        return
      end
  
      @young_person_management = YoungPersonManagement.new(young_person_id: @young_person.id)
    else
      flash[:alert] = "No user ID provided."
      @young_person_management = YoungPersonManagement.new
      render :new
      return
    end
  end
  
  
  


  def create
   
    @young_person_management = YoungPersonManagement.new(young_person_management_params)
    @young_person_management.active = :active
    
 
    @young_person = YoungPerson.find_by(user_id: @young_person_management.young_person_id)
    @supporters = Supporter.where(active: true)
    

    if @young_person.nil?
      flash.now[:alert] = 'Young person not found.'
      render :new
      return
    end
  

    YoungPersonManagement.where(young_person_id: @young_person.user_id, active: :active).each do |management|
      management.update(active: :unactive)
    end
  
    if @young_person_management.save
      redirect_to users_path, notice: 'Management record created successfully.'
    else
      flash.now[:alert] = 'Error creating management record.'
      render :new
    end
  end
  
  

  def edit
  end
  
  
  

  def update

  end
  
  
  

  


  def destroy
  end



  def passed_away
    @young_person = YoungPerson.find_by(user_id: params[:user_id])
    if @young_person
      @young_person.update(passed_away: true)
      redirect_to young_person_managements_path, notice: 'Young person has passed away.'
    else
      redirect_to young_person_managements_path, alert: 'Young person not found.'
    end
  end

  


  private

  def young_person_management_params
    params.require(:young_person_management).permit(:supporter_id, :young_person_id, :commit)
  end


  def set_young_person
    @young_person = YoungPerson.find_by(user_id: params[:id])
    redirect_to root_path, alert: 'Invalid user.' unless @young_person && current_user.can_manage?(@young_person)
  end
end
