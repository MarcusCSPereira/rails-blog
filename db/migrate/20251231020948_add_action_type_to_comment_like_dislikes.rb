# frozen_string_literal: true

class AddActionTypeToCommentLikeDislikes < ActiveRecord::Migration[8.1]
  def change
    add_column(:comment_like_dislikes, :action_type, :string)
    add_index(:comment_like_dislikes, [:comment_id, :user_id], unique: true)
  end
end
