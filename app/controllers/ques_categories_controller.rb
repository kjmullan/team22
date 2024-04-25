class QuesCategoriesController < ApplicationController
  before_action :set_ques_category, only: %i[ show edit update destroy ]

  # GET /ques_categories
  def index
    @ques_categories = QuesCategory.all
  end

  # GET /ques_categories/1
  def show
  end

  # GET /ques_categories/new
  def new
    @ques_category = QuesCategory.new
  end

  # GET /ques_categories/1/edit
  def edit
    # @question = Question.find(params[:id])
    # @ques_category = QuesCategory.all
  end

  # POST /ques_categories
  def create
    @ques_category = QuesCategory.new(ques_category_params)

    if @ques_category.save
      redirect_to ques_categories_path, notice: "Ques category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ques_categories/1
  def update
    if @ques_category.update(ques_category_params)
      redirect_to ques_categories_path, notice: "Question category was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /ques_categories/1
  def destroy
    @ques_category.destroy!
    redirect_to ques_categories_url, notice: "Ques category was successfully destroyed.", status: :see_other
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to ques_categories_url, alert: "Ques category could not be destroyed. Please ensure there are no dependent records."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ques_category
      @ques_category = QuesCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ques_category_params
      params.require(:ques_category).permit(:name, :active)
    end
end
