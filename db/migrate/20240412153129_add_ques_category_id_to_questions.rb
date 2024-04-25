class AddQuesCategoryIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :ques_category_id, :bigint
  end
end
