class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :name, null: false, default: ''
      t.text :content
      t.belongs_to :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
