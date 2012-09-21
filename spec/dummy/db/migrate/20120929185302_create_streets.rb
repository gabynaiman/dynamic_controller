class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.string :name
      t.references :city

      t.timestamps
    end
    add_index :streets, :city_id
  end
end
