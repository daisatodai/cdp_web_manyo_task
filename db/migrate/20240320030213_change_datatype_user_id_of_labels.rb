class ChangeDatatypeUserIdOfLabels < ActiveRecord::Migration[6.1]
  def change
    add_reference :labels, :user, foreign_key: true
  end
end
