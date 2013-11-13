class RenamemyPeople < ActiveRecord::Migration
  def change
    rename_table :my_people, :mypeople
  end
end
