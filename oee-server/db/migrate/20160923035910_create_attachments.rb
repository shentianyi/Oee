class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :path
      t.string :size
      t.string :type
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
  end
end
