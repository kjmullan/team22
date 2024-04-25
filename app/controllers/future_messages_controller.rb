# FutureMessagesController
# Manages the creation, display, update, deletion, and publication of future messages.
# This controller is restricted by role, ensuring that only authorized users can manage future messages.

class FutureMessagesController < ApplicationController
  # Ensures an authenticated user for all actions
  before_action :authenticate_user!
  # Ensures a future message is set for specific actions
  before_action :set_future_message, only: [:show, :edit, :update, :destroy]
  # Restricts index, edit, update, and destroy actions to users with appropriate roles
  before_action :ensure_young_person, only: [:index, :edit, :update, :destroy]
  # Restricts the publish action to admins
  before_action :ensure_admin, only: [:publish]

  # GET /future_messages
  # Displays future messages based on the user's role and associated young people or bubbles
  def index
    @future_messages = case current_user.role
    when "loved_one"
      fetch_loved_one_future_messages
    when "supporter"
      fetch_supporter_future_messages(params[:user_id])
    when "admin"
      FutureMessage.all
    when "young_person"
      current_user.future_messages
    else
      redirect_to root_path, alert: "You are not authorized to view this page." and return
    end
  end

  # GET /future_messages/1
  # Displays a single future message, details are fetched by before_action
  def show
  end

  # GET /future_messages/new
  # Initializes a new future message for creation
  def new
    @future_message = FutureMessage.new
    @bubbles = current_user.young_person.try(:bubbles) || []
  end

  # GET /future_messages/1/edit
  # Prepares an existing future message for editing
  def edit
    @bubbles = current_user.young_person.try(:bubbles) || []
  end

  # POST /future_messages
  # Creates a future message and saves it to the database
  def create
    @future_message = current_user.young_person.future_messages.new(future_message_params)
    if @future_message.save
      redirect_to @future_message, notice: "Future message was successfully created."
    else
      flash.now[:alert] = @future_message.errors.full_messages.to_sentence
      render :new
    end
  end

  # PATCH/PUT /future_messages/1
  # Updates an existing future message
  def update
    if @future_message.update(future_message_params)
      redirect_to @future_message, notice: "Future message was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /future_messages/1
  # Destroys a future message
  def destroy
    @future_message.destroy
    redirect_to future_messages_url, notice: "Future message was successfully destroyed."
  end

  # POST /future_messages/1/publish
  # Marks a future message as publishable by an admin
  def publish
    if @future_message.update(publishable: true)
      redirect_to future_messages_path, notice: 'Future message was successfully published.'
    else
      redirect_to future_messages_path, alert: 'Unable to publish the future message.'
    end
  end

  private
    # Finds the FutureMessage based on the ID provided in params
    def set_future_message
      @future_message = FutureMessage.find(params[:id])
    end

    # Permits only the allowed parameters through for creating or updating future messages
    def future_message_params
      params.require(:future_message).permit(:content, :published_at, bubble_ids: [])
    end

    # Checks if the user is authorized to perform certain actions based on their role
    def ensure_young_person
      unless current_user.young_person? || current_user.admin? || current_user.supporter?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end 

      restrict_admin_actions if current_user.admin?
    end

    # Ensures only admins can perform certain actions
    def ensure_admin
      unless current_user.admin?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end

    # Redirects admin if trying to perform actions restricted to non-admin roles
    def restrict_admin_actions
      case action_name
      when 'edit', 'update', 'create', 'destroy', 'new'
        redirect_to answers_path, alert: "You are not authorised to perform this action."
      end
    end
end
