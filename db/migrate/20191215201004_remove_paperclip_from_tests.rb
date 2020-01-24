class RemovePaperclipFromTests < ActiveRecord::Migration[5.2]
  def change
    remove_attachment :tests, :document
  end
end
