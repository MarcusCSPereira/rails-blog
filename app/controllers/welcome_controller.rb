# frozen_string_literal: true

class WelcomeController < PublicController
  def index
    @articles = Article.includes(:author, :category).with_attached_cover_image.order(updated_at: :desc).limit(6)
    @recent_categories = Category.with_attached_cover_image.order(created_at: :desc).limit(8)
  end
end
