# Api::V1::YoungPersonManagementsController
# Controller for managing interactions with the YoungPerson model for supporters.
# This controller allows authenticated users with supporter roles to access and manage young people's data,
# particularly their answers to various questions.
#
# File Naming:
# The file name matches the class name (young_person_managements_controller.rb) following Rails conventions.

class Api::V1::YoungPersonManagementsController < ActionController::API
  # Ensures user is authenticated before any action is performed.
  before_action :authenticate_user!

  # GET /api/young_person_managements
  # Retrieves young people associated with the current authenticated supporter user and their answers.
  # Returns JSON data including the answers.
  def index
    if current_user.supporter?
      @young_people = current_user.young_people.includes(:answers)
      render json: @young_people, include: [:answers]
    else
      # Responds with an access denied message if the current user is not a supporter.
      render json: { error: 'Access Denied' }, status: :forbidden
    end
  end

  # GET /api/young_person_managements/:id
  # Fetches and returns a specific young person's answers based on the user ID provided in the parameters.
  # Only returns data if the user's role is 'young_person'.
  def show
    @young_person = YoungPerson.find_by(user_id: params[:user_id])

    if @young_person&.role == 'young_person'
      @answers = @young_person.answers.includes(:question)
      render json: @answers, include: [:question]
    else
      # Responds with an error message if the young person does not exist or is not accessible.
      render json: { error: 'This user does not have answers or is not accessible.' }, status: :not_found
    end
  end
end

# Comments regarding methods:
# Each public method is documented with comments detailing its function, the expected parameters,
# and what it returns or the possible side effects.
# This helps to ensure that the controller's methods are easily understandable and maintainable.
#
# Documentation:
# Proper naming and commenting practices help to ensure that the controller's functionality is clearly understood.
# Additional documentation, such as an API guide or endpoint descriptions, should be provided separately to aid in using the API.

