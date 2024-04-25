class QuestionsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_question, only: %i[ show edit update destroy ]
  before_action :ensure_authorized_for_action, only: [:index, :show, :edit, :destroy, :update]


  # GET /questions
  def index
    if current_user.admin?
      @questions = Question.all
    else
      @questions = Question.where(active: true)
    end
  end

  # GET /questions/1
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    @ques_categories = QuesCategory.all
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    @ques_categories = QuesCategory.all
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.ques_category_id.nil?
      redirect_to new_question_path, alert: "Question category is required" and return 
    end
    
    if @question.content.strip == ""
      redirect_to new_question_path, alert: "Question content is required" and return 
    end

    if @question.save
      redirect_to questions_path, notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to questions_path, notice: "Question was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy

  end

  def make_unactive
    @question = Question.find(params[:id])
    
    if @question.update(active: false)
      redirect_to questions_url, notice: "Question was successfully deactivated.", status: :see_other
    else
      flash[:alert] = "Failed to deactivate Question."
      redirect_to questions_url, status: :see_other
    end
  end
  
  
  
  def request_change
    @question = Question.find(params[:id])
    @question.update(change: true)
    redirect_to @question, notice: 'Change request submitted successfully'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:content , :ques_category_id, :sensitivity, :active)
    end

    def ensure_authorized_for_action
      case action_name.to_sym
      when :index, :show
        unless current_user.admin? || current_user.supporter? || current_user.young_person?
          redirect_to root_path, alert: "You are not authorized to access this page."
        end
      when :edit, :destroy, :update
        redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
      end
    end
end
