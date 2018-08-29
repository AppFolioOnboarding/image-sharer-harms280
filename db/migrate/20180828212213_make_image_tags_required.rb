class MakeImageTagsRequired < ActiveRecord::Migration[5.2]
  def up
    image_ids = execute 'SELECT id FROM images WHERE id NOT IN (SELECT DISTINCT taggable_id FROM taggings);'
    reserved_tag_id = insert "INSERT INTO tags (name) VALUES ('legacy');"
    image_ids.each do |img|
      exec_insert "INSERT INTO taggings (tag_id,taggable_type,taggable_id,created_at,context)
                   VALUES ($1,'Image',$2, $3, '')",
                  'SQL', [[nil, reserved_tag_id], [nil, img['id']], [nil, Time.zone.now]]
    end
  end

  def down
    execute "DELETE FROM taggings WHERE tag_id IN (SELECT id FROM tags WHERE name = 'legacy' );"
    execute "DELETE FROM tags WHERE name = 'legacy'"
  end
end
