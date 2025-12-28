# frozen_string_literal: true

class AddCategoryToArticle < ActiveRecord::Migration[8.1]
  def change
    add_reference(:articles, :category, null: true, default: nil, foreign_key: true, type: :uuid)
  end
end
