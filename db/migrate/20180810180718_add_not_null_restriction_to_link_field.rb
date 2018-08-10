class AddNotNullRestrictionToLinkField < ActiveRecord::Migration[5.2]
  def change
    change_column_null :images, :link, false
  end
end
