class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name, null: false, default: ''
      t.boolean :global, default: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
