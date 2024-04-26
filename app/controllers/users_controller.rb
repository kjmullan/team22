class UsersController < ApplicationController
  before_action :set_user_message, only: %i[ show edit update destroy ]

  def show
    @user = User.find(params[:id])
    if @user.role == 'young_person' && @user.young_person
      @current_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: :active)
      @previous_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: :unactive)
  
      @current_supporters = @current_managements.map do |management|
        supporter = Supporter.find_by(user_id: management.supporter_id)
        [supporter, management] if supporter
      end.compact
  
      @previous_supporters = @previous_managements.map do |management|
        supporter = Supporter.find_by(user_id: management.supporter_id)
        [supporter, management] if supporter
      end.compact
    else
      @current_supporters = []
      @previous_supporters = []
    end
  end
  
  

  def index
    @users = User.all
    # @user = User.find(params[:id])
    # if @user.role == 'young_person' && @user.young_person
    #   @current_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: true)
    #   @previous_managements = YoungPersonManagement.where(young_person_id: @user.young_person.user_id, active: false)
  
    #   @current_supporters = @current_managements.map do |management|
    #     supporter = Supporter.find_by(user_id: management.supporter_id)
    #     [supporter, management] if supporter
    #   end.compact
  
    #   @previous_supporters = @previous_managements.map do |management|
    #     supporter = Supporter.find_by(user_id: management.supporter_id)
    #     [supporter, management] if supporter
    #   end.compact
    # else
    #   @current_supporters = []
    #   @previous_supporters = []
    # end
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)

      if current_user != @user
        redirect_to @user, notice: "User was successfully updated."
      else
        redirect_to request.referer, notice: "User was successfully updated."
      end
    else
      render :edit
    end
  end
  
  def make_supporter_unactive
    @user = User.find(params[:id])
    @supporter = Supporter.find_by(user_id: @user.id)
    @supporter.update(active: false)
    redirect_to users_path
  end

  def make_supporter_active
    @user = User.find(params[:id])
    @supporter = Supporter.find_by(user_id: @user.id)
    @supporter.update(active: true)
    redirect_to users_path
  end
  

  def create
    @user = User.new(user_params)
    
    # Retrieve the invite based on the token provided at signup
    invite = Invite.find_by(token: params[:user][:token])
    
    if invite && invite.expiration_date > Time.now && !invite.used
      @user.role = invite.role # Assign the role from the invite
      invite.update(used: true) # Mark the invite as used
      if @user.save
        redirect_to root_url, notice: "User was successfully created with role #{invite.role}."
      else
        render :new
      end
    else
      @user.errors.add(:token, 'is invalid or has expired')
      render :new, alert: "Invalid or expired token."
    end
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_message
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def future_message_params
      params.require(:user).permit(:id, :content, :published_at, :user_id)
    end

    def user_params
      permitted_params = [:name, :email, :pronouns, :status, :role, :token] # Added :token to the list to capture it during sign-up.
    
      if params[:user][:password].present? || params[:user][:password_confirmation].present?
        password = params[:user][:password].strip
        params[:user][:password] = password
        permitted_params << :password
      else
        permitted_params << :password if @user.encrypted_password.present?
      end
    
      params.require(:user).permit(permitted_params)
    end
end