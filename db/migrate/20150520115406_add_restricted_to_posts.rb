class AddRestrictedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :restricted, :boolean, default: false
  end
end
