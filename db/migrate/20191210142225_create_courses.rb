class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :user_id
      t.decimal :start_lat
      t.decimal :start_lng
      t.decimal :end_lat
      t.decimal :end_lng
      t.string :name
      t.timestamps
    end
  end
end
