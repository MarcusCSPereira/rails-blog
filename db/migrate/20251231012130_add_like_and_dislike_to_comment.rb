# frozen_string_literal: true

class AddLikeAndDislikeToComment < ActiveRecord::Migration[8.1]
  def change
    change_table(:comments, bulk: true) do |t|
      t.integer(:like, default: 0)
      t.integer(:dislike, default: 0)
    end
  end
end
