class CreateCsvObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :csv_objects do |t|
      t.bigint :object_id
      t.string :object_type
      t.json :object_data
      t.timestamps
    end
  end
end
