# frozen_string_literal: true

class PublicController < ApplicationController
  before_action :set_footer_data

  private

  def set_footer_data
    @recent_categories_footer = Category.order(created_at: :desc).limit(8)
    @recent_articles_footer = Article.includes(:author, :category).with_attached_cover_image.order(updated_at: :desc).limit(4)
  end
end
