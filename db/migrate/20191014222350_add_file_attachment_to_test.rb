class AddFileAttachmentToTest < ActiveRecord::Migration[5.2]
  def up
    add_attachment :tests, :document
  end

  def down
    remove_attachment :tests, :document
  end
end
