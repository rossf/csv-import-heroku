class CreateJobStatus < ActiveRecord::Migration[5.1]
  def change
    create_table :job_statuses do |t|
      t.string :active_job_id, null: false
      t.index :active_job_id
      t.integer :completed, default: 0
      t.integer :total
      t.string :status
      t.string :import_errors, array: true
    end
  end
end
