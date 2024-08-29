class AddDobToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :dob, :datetime
  end
end
