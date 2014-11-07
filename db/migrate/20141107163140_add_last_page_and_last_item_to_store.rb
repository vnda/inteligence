class AddLastPageAndLastItemToStore < ActiveRecord::Migration
  def change
    add_column :stores, :last_page, :integer, default: 1
    add_column :stores, :last_position, :integer, default: 0
  end
end
