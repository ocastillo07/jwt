class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :email
      t.integer :score
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :authors, :email
    add_index :authors, :score
  end
end
