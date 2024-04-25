# FutureMessageAlertsController
# Manages alert functionalities for future messages within the application.
# This controller handles the creation, updating, showing, and deletion of alerts associated with future messages.

class FutureMessageAlertsController < ApplicationController
  # Ensures an alert object is set up for specific actions that require an existing alert instance.
  before_action :set_future_message_alert, only: [:show, :edit, :update, :destroy]

  # GET /future_message_alerts
  # Lists all alerts related to the current user's associated young people.
  def index
    # Retrieve IDs of all young people related to the current user.
    young_person_ids = current_user.young_people.pluck(:id)

    # Fetch all alerts that belong to these young people.
    @future_message_alerts = FutureMessageAlert.where(young_person_id: young_person_ids)

    # Additionally fetches related future messages using the foreign key 'future_message_id' from alerts.
    future_message_ids = @future_message_alerts.pluck(:future_message_id)
    @future_messages = FutureMessage.where(id: future_message_ids, user_id: young_person_ids)
  end

  # GET /future_message_alerts/new
  # Prepares to create a new alert associated with a specific future message.
  def new
    @future_message = FutureMessage.find(params[:future_message_id])
    @future_message_alert = FutureMessageAlert.new(future_message_id: @future_message.id)
  end

  # POST /future_message_alerts
  # Creates a new alert based on parameters submitted from the form.
  def create
    Rails.logger.debug "Submitted parameters: #{params.inspect}"
    @future_message_alert = FutureMessageAlert.new(future_message_alert_params)
    if @future_message_alert.save
      redirect_to @future_message_alert, notice: 'Future message alert was successfully created.'
    else
      Rails.logger.debug "Errors: #{@future_message_alert.errors.full_messages}"
      render :new
    end      
  end

  # GET /future_message_alerts/:id
  # Shows details of a specific alert.
  def show
    # @future_message_alert is set by the set_future_message_alert method.
  end

  # GET /future_message_alerts/:id/edit
  # Prepares an existing alert for editing.
  def edit
    # Ensures that @future_message_alert is correctly associated with a future message.
    @future_message = @future_message_alert.future_message
  end
  
  # PATCH/PUT /future_message_alerts/:id
  # Updates an existing alert based on form data submitted.
  def update
    Rails.logger.debug "Received future_message_id: #{params.dig(:future_message_alert, :future_message_id)}"
    if @future_message_alert.update(future_message_alert_params)
      redirect_to @future_message_alert, notice: 'Future message alert was successfully updated.'
    else
      render :edit
    end
  end
  
  # DELETE /future_message_alerts/:id
  # Deactivates a future message alert rather than deleting it from the database.
  def destroy
    @future_message_alert = FutureMessageAlert.find(params[:id])
    if @future_message_alert.update(active: false)
      redirect_to future_message_alerts_url, notice: 'Future message alert was successfully deactivated.'
    else
      render :index, notice: 'Failed to deactivate future message alert.'
    end
  end

  private

  # Finds the FutureMessageAlert based on the ID provided in params.
  def set_future_message_alert
    @future_message_alert = FutureMessageAlert.find(params[:id])
  end

  # Permits only the safe parameters for creating or updating alerts.
  def future_message_alert_params
    params.require(:future_message_alert).permit(:future_message_id, :commit)
  end
end
