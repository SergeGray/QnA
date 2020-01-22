class AddIndexToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_index :answers, %i[question_id best], where: "(best is TRUE)"
  end
end
