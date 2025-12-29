# frozen_string_literal: true

class AddAuthorToArticle < ActiveRecord::Migration[8.1]
  def up
    # Primeiro, adiciona a coluna como nullable
    add_reference(:articles, :author, null: true, foreign_key: true, type: :uuid)

    default_author = Author.first || Author.create!(name: "Autor Padrão", description: "Autor Padrão", facebook_profile_url: "https://www.facebook.com/autorpadrao", instagram_profile_url: "https://www.instagram.com/autorpadrao", twitter_profile_url: "https://www.twitter.com/autorpadrao", linkedin_profile_url: "https://www.linkedin.com/autorpadrao", youtube_profile_url: "https://www.youtube.com/autorpadrao")
    # rubocop:disable Rails/SkipsModelValidations
    Article.where(author_id: nil).update_all(author_id: default_author.id)
    # rubocop:enable Rails/SkipsModelValidations

    # Depois, torna a coluna NOT NULL
    change_column_null(:articles, :author_id, false)
  end

  def down
    remove_reference(:articles, :author, foreign_key: true, type: :uuid)
  end
end
