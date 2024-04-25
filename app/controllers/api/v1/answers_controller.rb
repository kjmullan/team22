# app/controllers/api/v1/answers_controller.rb
# Provides actions for managing answers via API endpoints.
# Supports CRUD operations on answers linked to questions and user roles.
class Api::V1::AnswersController < ActionController::API
  # Authentication and specific callbacks for actions on answers.
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_young_person, only: [:edit, :update, :destroy]

  # GET /api/answers
  # Lists answers based on user roles and permissions.
  # - For loved ones: Lists answers within accessible bubbles.
  # - For supporters: Lists answers from a specific young person, if specified.
  # - For admins: Lists all answers.
  def index
    case current_user.role
    when "loved_one"
      bm = BubbleMember.find_by(user_id: current_user.id)
      invite = BubbleInvite.find_by(bubble_member_id: bm.id)
      bubble = invite&.bubbles
      
      answers_bubbles = AnswersBubble.where(bubble_id: bubble&.ids)
      answer_ids = answers_bubbles&.pluck(:answer_id)
      @answers = Answer.where(id: answer_ids)

    when "supporter"
      if params[:young_person_id]
        young_person = YoungPerson.find(params[:young_person_id])
        @answers = young_person.answers
      else
        render json: { error: "No young person selected" }, status: :bad_request
        return
      end

    when "admin"
      @answers = Answer.all

    else
      render json: { error: "You are not authorized to view this page" }, status: :unauthorized
      return
    end

    render json: @answers
  end

  # GET /api/answers/1
  # Shows a specific answer by ID.
  # Returns JSON representation of the answer.
  def show
    render json: @answer
  end

  # POST /api/answers
  # Creates a new answer linked to a question.
  # Required params: question_id, content
  # Optional params: media (attachments)
  # Returns the created answer or an error message.
  def create
    return render json: { error: 'User not found. Please sign in again.' }, status: :unauthorized if current_user.nil?

    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      attach_media(@answer, params[:media]) if params[:media].present?
      render json: @answer, status: :created, location: api_answer_url(@answer)
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/answers/1
  # Updates an existing answer.
  # Accepts the same parameters as create, adjusting existing data.
  # Returns the updated answer or an error message.
  def update
    if @answer.update(answer_params)
      attach_media(@answer, params[:media]) if params[:media].present?
      render json: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/answers/1
  # Deletes an answer and optionally its attached media.
  # Returns a confirmation message.
  def destroy
    @answer.media.purge_later 
    @answer.destroy
    render json: { notice: "Answer was successfully destroyed." }
  end

  # DELETE /api/answers/:id/media/:media_id
  # Removes a specific piece of media from an answer.
  # Returns a confirmation message.
  def remove_media
    media_attachment = ActiveStorage::Attachment.find(params[:media_id])
    media_attachment.purge_later
    render json: { notice: 'Media was successfully removed.' }
  end

  private

  # Finds an answer by ID. Used as a before_action for show, update, and destroy.
  def set_answer
    @answer = Answer.find_by(id: params[:id])
  end

  # Permits and sanitizes parameters for creating and updating answers.
  def answer_params
    params.require(:answer).permit(:content, :question_id, :user_id, bubble_ids: [])
  end
end