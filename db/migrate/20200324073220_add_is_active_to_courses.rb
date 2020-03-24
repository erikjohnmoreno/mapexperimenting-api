class AddIsActiveToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :is_active, :boolean, default: false
  end
end
