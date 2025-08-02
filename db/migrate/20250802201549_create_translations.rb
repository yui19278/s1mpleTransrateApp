class CreateTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :translations do |t|
      t.text :input_text
      t.text :translated_text

      t.timestamps
    end
  end
end
