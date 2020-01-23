class AddIndexToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_index :answers,
              %i[question_id best],
              unique: true,
              where: "(best is TRUE)"
  end
end
