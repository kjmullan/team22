# app/controllers/change_requests_controller.rb
class ChangeRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_supporter_admin, only: [:index, :show, :edit, :update, :destroy]
  def index
    @change_requests = ChangeRequest.all
    @questions = Question.all
  end

  def show
    @change_request = ChangeRequest.find(params[:id])
  end

  def new
    @question = Question.find(params[:question_id])
    @change_request = @question.change_requests.build
  end

  def create
    @question = Question.find(params[:question_id])
    @change_request = @question.change_requests.build(change_request_params)
    if @change_request.save
      redirect_to questions_path, notice: 'Change request was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @change_request = ChangeRequest.find(params[:id])
    @question = @change_request.question
    @change_request.destroy
    redirect_to change_requests_path, notice: 'Change request was successfully deleted.'
  end

  private

  def change_request_params
    params.require(:change_request).permit(:status, :question_id, :content)
  end
  
  def ensure_supporter_admin
    unless current_user.admin? || current_user.supporter?
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

end