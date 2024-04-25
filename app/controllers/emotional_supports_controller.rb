class EmotionalSupportsController < ApplicationController

    def index
      @emotional_supports = EmotionalSupport.all
    end

    def new
      @emotional_support = current_user.emotional_supports.build
    end
  
    def create
      @emotional_support = current_user.emotional_supports.build(emotional_support_params)
      if @emotional_support.save
        redirect_to questions_path, notice: 'Support request was successfully created.'
      else
        render :new
      end
    end
  
    private
  
    def emotional_support_params
      params.require(:emotional_support).permit(:content)
    end
  end
  